import 'package:flutter/material.dart';

class HomePageTemp extends StatelessWidget {
  final List<String> _opciones = [
    'uno',
    'dos',
    'tres',
    'cuatro',
    'cinco',
    'seis'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Componentes Temp'),
      ),
      body: ListView(children: _crearItemsCorta()),
    );
  }

  List<Widget> _crearItems() {
    List<Widget> lista = new List<Widget>();

    for (String opt in _opciones) {
      final tempWidget = ListTile(
        title: Text(opt),
      );
      lista..add(tempWidget)..add(Divider());
    }

    return lista;
  }

  List<Widget> _crearItemsCorta() {
    var widgets = _opciones.map((item) {
      return Column(
        children: [
          ListTile(
            title: Text(item),
            subtitle: Text('mesa que más apluada si'),
            leading: Icon(Icons.people),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          Divider(),
        ],
      );
    }).toList();

    return widgets;
  }
}
