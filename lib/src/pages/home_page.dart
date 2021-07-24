import 'package:flutter/material.dart';
import 'package:global_inv/src/objects/productArgumentsModel.dart';
import 'package:global_inv/src/objects/productModel.dart';
import 'package:global_inv/src/objects/productSaleModel.dart';
import 'package:global_inv/src/objects/saleModel.dart';
import 'package:global_inv/src/pages/drawer_lateral_menu.dart';
import 'package:global_inv/src/pages/product_page.dart';
import 'package:global_inv/src/providers/products_provider.dart';
import 'package:global_inv/src/providers/sales_provider.dart';
import 'package:global_inv/src/utils/search_delegate.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ProductsProvider productsProvider = new ProductsProvider();
  SalesProvider salesProvider = new SalesProvider();
  List<ProductSaleModel> shopingCartList = [];
  ProductModel searchResult;
  SaleModel currentSale = new SaleModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Global - Inv'),
        actions: <Widget>[
          IconButton(
              onPressed: () async {
                final finalResult =
                    await showSearch(context: context, delegate: DataSearch());
                setState(() {
                  searchResult = finalResult;
                  _showSnack("Slide the search result to dismiss");
                });
              },
              icon: Icon(
                Icons.search,
                color: Colors.white,
              )),
        ],
      ),
      bottomNavigationBar: Container(
          color: Colors.blue.shade700,
          child: ListTile(
            title: Text(
              "Total: " + currentSale.total.toString() + " ＄",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white),
            ),
            trailing: Container(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        shopingCartList.clear();
                        currentSale.total = 0;
                        shopingCartList.clear();
                      });
                    },
                  ),
                  VerticalDivider(
                    color: Colors.white,
                  ),
                  IconButton(
                      splashColor: Colors.red,
                      icon: Icon(Icons.check, color: Colors.white),
                      onPressed: () {
                        setState(() async {
                          if (shopingCartList.isNotEmpty) {
                            // currentSale.products = shopingCartList;
                            bool connectionResult =
                                await salesProvider.createSale(currentSale);
                            if (connectionResult) {
                              _showSnack("Successful purchase");
                              setState(() {
                                shopingCartList.clear();
                                currentSale.total = 0;
                                shopingCartList.clear();
                              });
                            } else {
                              _showSnack(
                                  "Failed purchase, please check your internet connection");
                            }
                          } else {
                            _showSnack(
                                "Please add at least 1 item to the shopping cart");
                          }
                        });
                      })
                ],
              ),
            ),
          )),
      drawer: DrawerLateralMenu(),
      body: Stack(
        children: [
          Container(
            alignment: Alignment.centerRight,
            width: 300,
            height: 300,
          ),
          Container(
            alignment: Alignment.centerRight,
            width: MediaQuery.of(context).size.width * 1,
            height: MediaQuery.of(context).size.height * 1,
          ),
          Positioned(
            top: 0,
            child: Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.height * 0.725,
              child: _lista(),
            ),
          ),
          _salesDraggableWidget(),
          Positioned(
            child: Container(
                child: searchResult == null
                    ? Container()
                    : Dismissible(
                        key: UniqueKey(),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue.shade400,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black54,
                                blurRadius: 15.0,
                                spreadRadius: 1.0,
                                offset: Offset(0.5, 0.5),
                              ),
                            ],
                          ),
                          alignment: Alignment.centerRight,
                          width: MediaQuery.of(context).size.width * 1,
                          height: 80,
                          child: ListTile(
                            title: Text(searchResult.name,
                                style: TextStyle(color: Colors.white)),
                            subtitle: Text(searchResult.price.toString() + "＄",
                                style: TextStyle(color: Colors.white)),
                            leading: Text(
                                searchResult.quantity.toString() + 'x',
                                style: TextStyle(color: Colors.white)),
                            trailing: IconButton(
                                icon: Icon(Icons.add_shopping_cart),
                                color: Colors.white,
                                onPressed: () {
                                  setState(() {
                                    ProductSaleModel currentProduct =
                                        new ProductSaleModel(
                                            idProduct: searchResult.id,
                                            name: searchResult.name,
                                            price: searchResult.price,
                                            quantity: 1,
                                            max: searchResult.quantity);
                                    var contain = shopingCartList.where(
                                        (element) =>
                                            element.idProduct ==
                                            currentProduct.idProduct);
                                    if (contain.isEmpty) {
                                      shopingCartList.add(currentProduct);
                                      currentSale.total = currentSale.total +
                                          currentProduct.price;
                                      _showSnack(searchResult.name +
                                          " added to the cart");
                                    } else {
                                      _showSnack(searchResult.name +
                                          " already in the cart, modify the quantity below");
                                    }
                                  });
                                }),
                            onTap: () {
                              Navigator.pushNamed(
                                  context, ProductPage.routeName,
                                  arguments: ProductArguments(
                                      searchResult.name, searchResult));
                            },
                          ),
                        ),
                        onDismissed: (direction) {
                          setState(() {
                            searchResult = null;
                          });
                        })),
          ),
        ],
      ),
    );
  }

  Widget _lista() {
    return FutureBuilder(
      future: productsProvider.readProducts(),
      builder:
          (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot) {
        if (snapshot.hasData) {
          var productsList = snapshot.data;
          productsList =
              productsList.where((element) => element.quantity > 0).toList();
          return ListView.builder(
              itemCount: productsList.length,
              itemBuilder: (context, i) => _showProductWidget(productsList[i]));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _showProductWidget(ProductModel product) {
    return ListTile(
      title: Text(product.name),
      subtitle: Text(product.price.toString() + "＄"),
      leading: Text(product.quantity.toString() + 'x'),
      trailing: IconButton(
          icon: Icon(Icons.add_shopping_cart),
          onPressed: () {
            setState(() {
              ProductSaleModel currentProduct = new ProductSaleModel(
                  idProduct: product.id,
                  name: product.name,
                  price: product.price,
                  quantity: 1,
                  max: product.quantity);
              var contain = shopingCartList.where(
                  (element) => element.idProduct == currentProduct.idProduct);
              if (contain.isEmpty) {
                shopingCartList.add(currentProduct);
                currentSale.total = currentSale.total + currentProduct.price;
                _showSnack(product.name + " added to the cart");
              } else {
                _showSnack(product.name +
                    " already in the cart, modify the quantity below");
              }
            });
          }),
      onTap: () {
        Navigator.pushNamed(context, ProductPage.routeName,
            arguments: ProductArguments(product.name, product));
      },
    );
  }

  Widget _salesDraggableWidget() {
    return DraggableScrollableSheet(
        initialChildSize: 0.2,
        minChildSize: 0.1,
        maxChildSize: 0.7,
        builder: (context, scrollController) {
          return Container(
              child: ListView.builder(
                  controller: scrollController,
                  itemCount: shopingCartList.length,
                  itemBuilder: (context, i) {
                    return ListTile(
                      selectedTileColor: Color(200),
                      leading: Text(
                          shopingCartList[i].quantity.toString() + 'x',
                          style: TextStyle(color: Colors.white)),
                      title: Text(shopingCartList[i].name,
                          style: TextStyle(color: Colors.white)),
                      subtitle: Text(
                          (shopingCartList[i].quantity *
                                  shopingCartList[i].price)
                              .toString(),
                          style: TextStyle(color: Colors.white)),
                      trailing: Container(
                          child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () => {
                              setState(() {
                                if (shopingCartList[i].quantity <
                                    shopingCartList[i].max) {
                                  shopingCartList[i].quantity =
                                      shopingCartList[i].quantity + 1;
                                  currentSale.total = currentSale.total +
                                      shopingCartList[i].price;
                                }
                              })
                            },
                          ),
                          VerticalDivider(),
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () => {
                              setState(() {
                                if (shopingCartList[i].quantity >= 1) {
                                  shopingCartList[i].quantity =
                                      shopingCartList[i].quantity - 1;
                                  currentSale.total = currentSale.total -
                                      shopingCartList[i].price;
                                }
                              })
                            },
                          )
                        ],
                      )),
                    );
                  }),
              decoration: BoxDecoration(
                color: Colors.blue.shade700,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
              ));
        });
  }

  _showSnack(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'close',
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
