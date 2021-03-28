import 'package:flutter/material.dart';

class ContadorPage extends StatefulWidget {
  @override
  createState() => _ContadorPageState();
}

class _ContadorPageState extends State<ContadorPage> {
  final _estiloTexto = new TextStyle(fontSize: 20);
  int _contador = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Título'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Perreo hp', style: _estiloTexto),
            Text('$_contador', style: _estiloTexto),
          ],
        ),
      ),
      floatingActionButton: _crearBotones(),
    );
  }

  Widget _crearBotones() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: 30),
        FloatingActionButton(
            child: Icon(Icons.exposure_minus_1),
            onPressed: () => _funcBoton(-1)),
        Expanded(child: SizedBox()),
        FloatingActionButton(
            child: Icon(Icons.exposure_zero), onPressed: () => _funcBoton(0)),
        Expanded(child: SizedBox()),
        FloatingActionButton(
            child: Icon(Icons.exposure_plus_1), onPressed: () => _funcBoton(1)),
      ],
    );
  }

  void _funcBoton(int valor) {
    if (valor != 0) {
      setState(() => _contador = _contador + valor);
    } else {
      setState(() => _contador = 0);
    }
  }
}
