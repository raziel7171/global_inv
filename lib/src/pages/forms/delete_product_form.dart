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
  ProductsProvider productsProvider = new ProductsProvider();
  ProductModel searchResult;

  Future<List<ProductModel>> _productList(BuildContext context) async {
    return productsProvider.readProducts();
  }

//se aplica la misma lógica del editar producto, primero se debe ubicar el producto y seguido se le da slide(swipe) para eliminarlo
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
                  }); //objeto de busqueda que nos abre la interfaz para buscar un producto, este lo retornará al principio del listado en un color más oscuro
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
                      //dismissible es una propiedad para los tiles que permite que sean descartados de la lista, funcioan perfecto para una funcionalidad de eliminar
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
                        //se debe replicar el comportamiento de elminado para el de busqueda encontrada y para la lista
                        setState(() {
                          //llama el método deleteInteraction que se encarga de eliminar el elemento envíado searchResult y luego limpia la variable
                          _deleteInteraction(searchResult);
                          searchResult = null;
                        });
                        return null;
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
        //como se describió al principio se debe replicar el comportamiento de dismissible para la busqueda y los tiles de la lista
        key:
            UniqueKey(), //unique Key hace referencia a que cada elemento que se muestra en la lista debe ser único y gracias a esto se puede trabajar cada elemento de manera independiente
        background: Container(
            color: Colors.red, child: Icon(Icons.delete, color: Colors.white)),
        child: ListTile(
          title: Text(product.name),
          subtitle: Text(product.price.toString() + "＄"),
          leading: Text(product.quantity.toString() + 'x'),
          trailing: IconButton(
            icon: Icon(Icons.info),
            onPressed:
                () {}, //este método se encuentra vacío ya que si no se agrega nos mostrará una advertencia
          ),
          onTap: () {
            Navigator.pushNamed(context, ProductPage.routeName,
                arguments: ProductArguments(product.name,
                    product)); //si es seleccionado el tile este nos redirige a la página del producto
          },
        ),
        confirmDismiss: (direction) => _deleteInteraction(
            //usaremos el confirm dismiss llegado el caso que suceda un error este no se elimine
            product)); //igual que con el searchResult este envía el producto seleccionado
  }

  Future<bool> _deleteInteraction(ProductModel product) async {
    //se trabaja como una función asíncrona por el hecho de que va a esperar una respuesta en el futuro
    //en este caso por que la solicitud a firebase puede fallar
    bool connectionResult = false;
    connectionResult = await productsProvider.deleteProduct(product.id);
    if (connectionResult) {
      final snackBar = SnackBar(
        content: Text("Product: " + product.name + " succesfully deleted"),
        action: SnackBarAction(
          label: 'close',
          onPressed: () {},
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      final snackBar = SnackBar(
        content: Text(
            //nos mostrará este mensaje si el producto falló en eliminarse en la solicitud
            'The product could not be deleted check your internet connection'),
        action: SnackBarAction(
          label: 'close',
          onPressed: () {},
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    return connectionResult; //nos retornará un booleano para confirmarnos el proceso
  }
}
