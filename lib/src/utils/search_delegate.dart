import 'package:flutter/material.dart';
import 'package:global_inv/src/objects/productModel.dart';
import 'package:global_inv/src/providers/products_provider.dart';

class DataSearch extends SearchDelegate<ProductModel> {
  ProductsProvider productsProvider = new ProductsProvider();
//para trabajar la busquedas de maneras individuales se creo un elemento llamado DataSearch, este se encargará de retornar los productos donde se necesiten en la aplicación

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: Icon(Icons.clear)),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation));
  }

  @override
  Widget buildResults(BuildContext context) {
    //se genera un futureBuilder esperando la respuesta del productProvider, que nos retornará la lista de los productos
    return FutureBuilder(
        future: productsProvider.readProducts(),
        builder:
            (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot) {
          if (snapshot.hasData) {
            final lowerCaseQuery = query.toLowerCase();
            List<ProductModel> productsList = snapshot.data;
            final finalProductsList = productsList
                .where((specificElement) =>
                    specificElement.name.toLowerCase().contains(lowerCaseQuery))
                .toList(); //aquí se filtrará los productos cuyo nombre haga match con lo que se esté escribiendo en el campo de busqueda (se pasan los 2 a minúscula para evitar problemas)
            return ListView.builder(
                itemBuilder: (context, index) => ListTile(
                      title: RichText(
                        text: TextSpan(
                            text: finalProductsList[index]
                                .name
                                .toLowerCase()
                                .substring(
                                    0,
                                    finalProductsList[index]
                                        .name
                                        .toLowerCase()
                                        .indexOf(lowerCaseQuery)),
                            style: TextStyle(color: Colors.grey),
                            children: [
                              TextSpan(
                                  text: finalProductsList[index].name.substring(
                                      finalProductsList[index]
                                          .name
                                          .toLowerCase()
                                          .indexOf(lowerCaseQuery),
                                      finalProductsList[index]
                                              .name
                                              .toLowerCase()
                                              .indexOf(lowerCaseQuery) +
                                          query.length),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: finalProductsList[index]
                                      .name
                                      .toLowerCase()
                                      .substring(finalProductsList[index]
                                              .name
                                              .toLowerCase()
                                              .indexOf(lowerCaseQuery) +
                                          query.length),
                                  style: TextStyle(color: Colors.grey))
                            ]),
                      ),
                      onTap: () {
                        query = finalProductsList[index].name.toLowerCase();
                        close(context, finalProductsList[index]);
                      },
                    ),
                itemCount: finalProductsList.length);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //igualmente se contiene un listado de los productos sugeridos que no necesariamente sean los mejores candidatos a la busqueda, funciona con la misma logica
    return FutureBuilder(
        future: productsProvider.readProducts(),
        builder:
            (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot) {
          if (snapshot.hasData) {
            final lowerCaseQuery = query.toLowerCase();
            List<ProductModel> productsList = snapshot.data;
            final finalProductsList = productsList
                .where((specificElement) =>
                    specificElement.name.toLowerCase().contains(lowerCaseQuery))
                .toList();
            return ListView.builder(
                itemBuilder: (context, index) => ListTile(
                      title: RichText(
                        text: TextSpan(
                            text: finalProductsList[index]
                                .name
                                .toLowerCase()
                                .substring(
                                    0,
                                    finalProductsList[index]
                                        .name
                                        .toLowerCase()
                                        .indexOf(lowerCaseQuery)),
                            style: TextStyle(color: Colors.grey),
                            children: [
                              TextSpan(
                                  text: finalProductsList[index]
                                      .name
                                      .toLowerCase()
                                      .substring(
                                          finalProductsList[index]
                                              .name
                                              .toLowerCase()
                                              .indexOf(lowerCaseQuery),
                                          finalProductsList[index]
                                                  .name
                                                  .toLowerCase()
                                                  .indexOf(lowerCaseQuery) +
                                              query.length),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: finalProductsList[index]
                                      .name
                                      .toLowerCase()
                                      .substring(finalProductsList[index]
                                              .name
                                              .toLowerCase()
                                              .indexOf(lowerCaseQuery) +
                                          query.length),
                                  style: TextStyle(color: Colors.grey))
                            ]),
                      ),
                      onTap: () {
                        query = finalProductsList[index].name.toLowerCase();
                        close(context, finalProductsList[index]);
                      },
                    ),
                itemCount: finalProductsList.length);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
