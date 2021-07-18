import 'package:flutter/material.dart';
import 'package:global_inv/src/objects/productModel.dart';
import 'package:global_inv/src/pages/add_product_form.dart';
import 'package:global_inv/src/pages/product_page.dart';
import 'package:global_inv/src/providers/products_provider.dart';
import 'package:global_inv/src/utils/icon_string_util.dart';

import 'add_product_form.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ProductsProvider productsProvider = new ProductsProvider();
  List<ProductModel> productList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Global - Inv'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.menu),
        onPressed: () {
          Navigator.pushNamed(context, AddProductForm.routeName);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      bottomNavigationBar: Container(
          color: Colors.lightGreen.shade100,
          child: ListTile(
            title: Text(
              "Total: 10000 ＄",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            trailing: IconButton(
                icon: Icon(Icons.shopping_cart), onPressed: () => null),
          )),
      body: Stack(
        children: [
          Positioned(child: _lista()),
          Positioned.fill(
              child: DraggableScrollableSheet(
                  maxChildSize: 0.7,
                  minChildSize: 0.12,
                  builder: (_, controller) {
                    return Material(
                      elevation: 10,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      color: Colors.lightGreen.shade100,
                      child: Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Expanded(
                              child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  controller: controller,
                                  itemCount: 10,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: Text('10x'),
                                      title: Text('index: $index'),
                                      subtitle: Text('summatoria 1500＄'),
                                      trailing: Container(
                                          // color: Colors.lightBlueAccent,
                                          child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          IconButton(
                                            icon: const Icon(Icons.add),
                                            onPressed: () => null,
                                          ),
                                          VerticalDivider(),
                                          IconButton(
                                            icon: const Icon(Icons.remove),
                                            onPressed: () => null,
                                          )
                                        ],
                                      )),
                                    );
                                  }))),
                    );
                  }))
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
          icon: getIcon(product.icon), onPressed: () => product.quantity - 1),
      onTap: () {
        Navigator.pushNamed(context, ProductPage.routeName,
            arguments: ProductArguments(product.name, product));
      },
    );
  }

  void subtract(dynamic product) => product['quantity'] - 1;
}

class ProductArguments {
  final String name;
  final dynamic specificProduct;
  ProductArguments(this.name, this.specificProduct);
}
