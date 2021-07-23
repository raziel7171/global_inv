import 'package:flutter/material.dart';
import 'package:global_inv/src/objects/productArgumentsModel.dart';
import 'package:global_inv/src/objects/productModel.dart';
import 'package:global_inv/src/pages/forms/edit_specific_product_form.dart';
import 'package:global_inv/src/providers/products_provider.dart';
import 'package:global_inv/src/utils/search_delegate.dart';
import '../product_page.dart';

class EditProductForm extends StatefulWidget {
  static const routeName = '/editProduct';
  @override
  _EditProductFormState createState() => _EditProductFormState();
}

class _EditProductFormState extends State<EditProductForm> {
  ProductsProvider productsProvider = new ProductsProvider();
  ProductModel searchResult;
  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  Future<List<ProductModel>> _productList(BuildContext context) async {
    return productsProvider.readProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.amberAccent.shade700,
          title: Text('Edit product'),
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
                  color: Colors.amberAccent.shade200,
                  child: ListTile(
                    title: Text(searchResult.name,
                        style: TextStyle(color: Colors.white)),
                    subtitle: Text(searchResult.price.toString() + "＄",
                        style: TextStyle(color: Colors.white)),
                    leading: Text(searchResult.quantity.toString() + 'x',
                        style: TextStyle(color: Colors.white)),
                    trailing: IconButton(
                        icon: Icon(Icons.edit),
                        color: Colors.white,
                        onPressed: () {
                          setState(() {
                            _editInteraction(searchResult);
                            searchResult = null;
                          });
                        }),
                    onTap: () {
                      Navigator.pushNamed(context, ProductPage.routeName,
                              arguments: ProductArguments(
                                  searchResult.name, searchResult))
                          .then((value) => (context as Element).reassemble());
                    },
                  ),
                ),
          Expanded(child: _lista())
        ],
      ),
      bottomNavigationBar: Container(
          color: Colors.amberAccent.shade100,
          child: ListTile(
            title: Text(
              "Tap the edit button to modify or tap the product name to get more info about it",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: IconButton(
              icon: Icon(Icons.info),
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
    return ListTile(
      title: Text(product.name),
      subtitle: Text(product.price.toString() + "＄"),
      leading: Text(product.quantity.toString() + 'x'),
      trailing: IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          _editInteraction(product);
        },
      ),
      onTap: () {
        Navigator.pushNamed(context, ProductPage.routeName,
            arguments: ProductArguments(product.name, product));
      },
    );
  }

  _editInteraction(ProductModel product) {
    Navigator.pushNamed(context, EditSpecificProductForm.routeName,
        arguments: ProductArguments(product.name, product));
    setState(() {});
    (context as Element).reassemble();
  }
}
