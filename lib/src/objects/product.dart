import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class Product extends ChangeNotifier {
  Product(this._code, this._name, this._price, this._quantity, this._icon,
      this._description, this._route);

  String _code;
  String _name;
  double _price;
  int _quantity;
  String _icon;
  String _description;
  String _route;

  Product.Map(dynamic obj) {
    this._code = obj['code'];
    this._name = obj['name'];
    this._price = obj['price'];
    this._quantity = obj['quantity'];
    this._icon = obj['icon'];
    this._description = obj['description'];
    this._route = obj['route'];
    notifyListeners();
  }

  String get code => _code;
  String get name => _name;
  double get price => _price;
  int get quantity => _quantity;
  String get icon => _icon;
  String get description => _description;
  String get route => _route;

  Product.fromSnapShot(DataSnapshot snapShot) {
    _code = snapShot.key;
    _name = snapShot.value['name'];
    _price = snapShot.value['price'];
    _quantity = snapShot.value['quantity'];
    _icon = snapShot.value['icon'];
    _description = snapShot.value['description'];
    _route = snapShot.value['route'];
    notifyListeners();
  }
}
