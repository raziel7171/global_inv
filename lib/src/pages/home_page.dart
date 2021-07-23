import 'dart:async';

import 'package:flutter/material.dart';
import 'package:global_inv/src/objects/productArgumentsModel.dart';
import 'package:global_inv/src/objects/productModel.dart';
import 'package:global_inv/src/pages/drawer_lateral_menu.dart';
import 'package:global_inv/src/pages/product_page.dart';
import 'package:global_inv/src/providers/products_provider.dart';
import 'package:global_inv/src/utils/icon_string_util.dart';
import 'package:global_inv/src/utils/search_delegate.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ProductsProvider productsProvider = new ProductsProvider();
  List<ProductModel> productList = [];
  StreamController<ProductModel> streamController;
  ProductModel searchResult;

  @override
  void initState() {
    super.initState();
    streamController = StreamController.broadcast();
    streamController.stream.listen((product) {
      setState(() {
        productList.add(product);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
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
                            color: Colors.blueAccent.shade100,
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
                                    productList.add(searchResult);
                                    _showSnack(searchResult.name +
                                        " added to the cart");
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
          final productsList = snapshot.data;
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
              productList.add(product);
              _showSnack(product.name + " added to the cart");
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
        minChildSize: 0.2,
        maxChildSize: 0.7,
        builder: (context, scrollController) {
          return Container(
              child: ListView.builder(
                  controller: scrollController,
                  itemCount: productList.length,
                  itemBuilder: (context, i) {
                    return ListTile(
                      title: Text(productList[i].name),
                    );
                  }),
              decoration: BoxDecoration(
                color: Colors.greenAccent.shade200,
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
