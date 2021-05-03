import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math';

// Define a custom Form widget.
class AddProductForm extends StatefulWidget {
  static const routeName = '/addProduct';

  @override
  _AddProductFormState createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map data;
  bool _autoValidate = false;
  String _name;
  double _price;
  int _quantity = 0;
  static const _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
  Random _rnd = Random();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a product'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            // autovalidate: _autoValidate,
            child: FormUI(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          addData();
        },
      ),
    );
  }

  Widget FormUI() {
    return Column(
      children: <Widget>[
        TextFormField(
          decoration: const InputDecoration(labelText: 'Name'),
          keyboardType: TextInputType.text,
          validator: validateName,
          onSaved: (String val) {
            _name = val;
          },
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Price'),
          keyboardType: TextInputType.number,
          validator: validatePrice,
          onSaved: (String val) {
            _price = double.parse(val);
          },
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Quantity'),
          keyboardType: TextInputType.number,
          validator: validateQuantity,
          onSaved: (String val) {
            _quantity = int.parse(val);
          },
        ),
        SizedBox(
          height: 10.0,
        ),
        RaisedButton(
          onPressed: _validateInputs,
          child: new Text('Validate'),
        ),
      ],
    );
  }

  String validateName(String value) {
    if (value.length < 3)
      return 'Name must be more than 2 charater';
    else
      return null;
  }

  String validatePrice(String value) {
    if (double.parse(value) < 50.0)
      return 'The minimum price must be over 50 (COP)';
    else
      return null;
  }

  String validateQuantity(String value) {
    if (value.contains('.') || value.contains(',') || value == "")
      return 'the number must be an integer';
    else if (int.parse(value) < 0)
      return 'The minimum quantity must be a positive number or zero';
    else
      return null;
  }

  void _validateInputs() {
    if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
      _formKey.currentState.save();
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }

  addData() {
    String _productCode = getRandomString(5);
    Map<String, dynamic> productData = {
      "code": _productCode,
      "name": _name,
      "price": _price,
      "quantity": _quantity,
      "icon": "add_shopping_cart",
      "route": "product",
      "description":
          "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
    };

    Map<String, dynamic> inventoryData = {
      "code": _productCode,
      "quantity": _quantity,
    };

    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('products');
    collectionReference.add(productData);

    collectionReference = FirebaseFirestore.instance.collection('inventory');
    collectionReference.add(inventoryData);
  }

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
}
