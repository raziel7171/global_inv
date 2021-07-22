import 'package:flutter/material.dart';
import 'package:global_inv/src/objects/productArgumentsModel.dart';
import 'package:global_inv/src/objects/productModel.dart';
import 'package:global_inv/src/providers/products_provider.dart';
import 'package:global_inv/src/utils/search_delegate.dart';
import '../product_page.dart';

class DeleteProductForm extends StatefulWidget {
  static const routeName = '/deleteProduct';
  @override
  _DeleteProductFormState createState() => _DeleteProductFormState();
}

class _DeleteProductFormState extends State<DeleteProductForm> {
  TextEditingController _searchController = TextEditingController();
  ProductsProvider productsProvider = new ProductsProvider();
  ProductModel searchResult;

  Future<List<ProductModel>> _productList(BuildContext context) async {
    return productsProvider.readProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.redAccent.shade700,
          title: Text('Delete product'),
          actions: <Widget>[
            IconButton(
                onPressed: () async {
                  final finalResult = await showSearch(
                      context: context, delegate: DataSearch());
                  setState(() {
                    searchResult = finalResult;
                  });
                },
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                )),
          ]),
      body: Column(
        children: [
          searchResult == null
              ? Container()
              : Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  color: Colors.redAccent.shade200,
                  child: Dismissible(
                      key: UniqueKey(),
                      background: Container(
                          color: Colors.red,
                          child: Icon(Icons.delete, color: Colors.white)),
                      child: ListTile(
                        title: Text(searchResult.name,
                            style: TextStyle(color: Colors.white)),
                        subtitle: Text(searchResult.price.toString() + "＄",
                            style: TextStyle(color: Colors.white)),
                        leading: Text(searchResult.quantity.toString() + 'x',
                            style: TextStyle(color: Colors.white)),
                        trailing: IconButton(
                            icon: Icon(Icons.info),
                            color: Colors.white,
                            onPressed: () => searchResult.quantity - 1),
                        onTap: () {
                          Navigator.pushNamed(context, ProductPage.routeName,
                              arguments: ProductArguments(
                                  searchResult.name, searchResult));
                        },
                      ),
                      confirmDismiss: (direction) async {
                        setState(() {
                          _deleteInteraction(searchResult);
                          searchResult = null;
                        });
                      })),
          Expanded(child: _lista())
        ],
      ),
      bottomNavigationBar: Container(
          color: Colors.red.shade100,
          child: ListTile(
            title: Text(
              "Slide the products you want to delete or tap on them to get more info",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: IconButton(
              icon: Icon(Icons.swap_horiz),
              onPressed: () {},
            ),
          )),
    );
  }

  Widget _lista() {
    return FutureBuilder(
      future: _productList(context),
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
    return Dismissible(
        key: UniqueKey(),
        background: Container(
            color: Colors.red, child: Icon(Icons.delete, color: Colors.white)),
        child: ListTile(
          title: Text(product.name),
          subtitle: Text(product.price.toString() + "＄"),
          leading: Text(product.quantity.toString() + 'x'),
          trailing: IconButton(
            icon: Icon(Icons.info),
            onPressed: () {},
          ),
          onTap: () {
            Navigator.pushNamed(context, ProductPage.routeName,
                arguments: ProductArguments(product.name, product));
          },
        ),
        confirmDismiss: (direction) => _deleteInteraction(product));
  }

  Future<bool> _deleteInteraction(ProductModel product) async {
    bool connectionResult = false;
    connectionResult = await productsProvider.deleteProduct(product.id);
    if (connectionResult) {
      final snackBar = SnackBar(
        content: Text('Product $product.name succesfully deleted'),
        action: SnackBarAction(
          label: 'close',
          onPressed: () {},
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final snackBar = SnackBar(
        content: Text(
            'The product could not be deleted check your internet connection'),
        action: SnackBarAction(
          label: 'close',
          onPressed: () {},
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    return connectionResult;
  }
}
