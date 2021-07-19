import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:global_inv/src/objects/productModel.dart';
import 'package:global_inv/src/providers/products_provider.dart';

// Define a custom Form widget.
class AddProductForm extends StatefulWidget {
  static const routeName = '/addProduct';

  @override
  _AddProductFormState createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  ProductModel product = new ProductModel();
  ProductsProvider productsProvider = new ProductsProvider();

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
            product.name = val;
          },
        ),
        TextFormField(
          initialValue: product.quantity.toString(),
          decoration: const InputDecoration(labelText: 'Price'),
          keyboardType: TextInputType.number,
          validator: validatePrice,
          onSaved: (String val) {
            _price = double.parse(val);
            product.price = double.parse(val);
          },
        ),
        TextFormField(
          initialValue: product.quantity.toString(),
          decoration: const InputDecoration(labelText: 'Quantity'),
          keyboardType: TextInputType.number,
          validator: validateQuantity,
          onSaved: (String val) {
            _quantity = int.parse(val);
            product.quantity = int.parse(val);
          },
        ),
        SizedBox(
          height: 10.0,
        ),
        ElevatedButton(
          onPressed: () {
            addData();
          },
          child: Text('Add product'),
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
    double _numValue = 0;
    if (value != "") {
      _numValue = double.parse(value);
    }
    if (_numValue < 50.0) {
      return 'The minimum price must be over 50 (COP)';
    } else {
      return null;
    }
  }

  String validateQuantity(String value) {
    if (value.contains('.') || value.contains(',') || value == "")
      return 'the number must be an integer';
    else if (int.parse(value) < 0)
      return 'The minimum quantity must be a positive number or zero';
    else
      return null;
  }

  bool _validateInputs() {
    if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
      _formKey.currentState.save();
      return true;
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
      return false;
    }
  }

  addData() async {
    bool formIsValid = _validateInputs();
    bool connectionResult = false;
    String _productCode = getRandomString(5);
    // product.id = _productCode;
    product.icon = "add_shopping_cart";
    product.route = "product";
    product.description =
        "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.";

    if (formIsValid) {
      connectionResult = await productsProvider.createProduct(product);
      if (connectionResult) {
        final snackBar = SnackBar(
          content: Text('Product added!'),
          action: SnackBarAction(
            label: 'close',
            onPressed: () {},
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        final snackBar = SnackBar(
          content: Text(
              'The product could not be added check your internet connection'),
          action: SnackBarAction(
            label: 'close',
            onPressed: () {},
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
}
