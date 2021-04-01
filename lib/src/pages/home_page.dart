import 'package:flutter/material.dart';
import 'package:global_inv/src/providers/menu_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Componentes'),
      ),
      body: _lista(),
    );
  }

  Widget _lista() {
    return FutureBuilder(
      future: menuProvider.cargarData(),
      initialData: [],
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        return ListView(
          children: _listaItems(snapshot.data),
        );
      },
    );
  }

  List<Widget> _listaItems(List<dynamic> data) {
    final List<Widget> opciones = [];

    data.forEach((opt) {
      final widgetTemp = ListTile(
        title: Text(opt['productName']),
        subtitle: Text(opt['productPrice'].toString()),
        leading: Text(opt['quantity'].toString() + 'x'),
        trailing: Icon(Icons.attach_money_sharp, color: Colors.green[400]),
        onTap: () {},
      );
      opciones..add(widgetTemp)..add(Divider());
    });
    return opciones;
  }
}
