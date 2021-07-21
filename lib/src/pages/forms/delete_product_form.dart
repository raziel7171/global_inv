import 'package:flutter/material.dart';
import 'package:global_inv/src/objects/productArgumentsModel.dart';
import 'package:global_inv/src/objects/productModel.dart';
import 'package:global_inv/src/providers/products_provider.dart';
import '../product_page.dart';

class DeleteProductform extends StatefulWidget {
  static const routeName = '/deleteProduct';
  @override
  _DeleteProductformState createState() => _DeleteProductformState();
}

class _DeleteProductformState extends State<DeleteProductform> {
  TextEditingController _searchController = TextEditingController();
  ProductsProvider productsProvider = new ProductsProvider();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      // ignore: unnecessary_statements
      _onSearchChanged;
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<List<ProductModel>> _productList(BuildContext context) async {
    return productsProvider.readProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent.shade700,
        title: Text('Delete product'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(prefixIcon: Icon(Icons.search)),
              ),
              Expanded(
                  child: Stack(
                children: [Positioned(child: _lista())],
              ))
            ],
          )
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
              icon: Icon(Icons.warning),
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

  void _onSearchChanged() {
    print(_searchController.text);
  }
}
