import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

class _MenuProvider {
  List<dynamic> opciones = [];

  _MenuProvider() {}

  Future<List<dynamic>> cargarData() async {
    final resp =
        await rootBundle.loadString('lib/src/assets/data/products.json');
    Map dataMap = json.decode(resp);
    opciones = dataMap['products'];

    return opciones;
  }
}

final menuProvider = new _MenuProvider();
