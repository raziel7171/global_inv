import 'dart:convert';
import 'package:global_inv/src/objects/productModel.dart';
import 'package:http/http.dart' as http;

class ProductsProvider {
  final String _url = 'https://global-inv-default-rtdb.firebaseio.com';

  Future<bool> createProduct(ProductModel product) async {
    final url = '$_url/products.json';

    try {
      final response =
          await http.post(Uri.parse(url), body: productModelToJson(product));
      final decodedData = json.decode(response.body);
      if (decodedData != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error trying to add new product');
      return false;
    }
  }

  Future<List<ProductModel>> readProducts() async {
    final url = '$_url/products.json';
    try {
      final response = await http.get(Uri.parse(url));
      final Map<String, dynamic> decodedData = json.decode(response.body);
      final List<ProductModel> productsList = [];

      if (decodedData == null) return [];

      decodedData.forEach((id, product) {
        final currentProduct = ProductModel.fromJson(product);
        currentProduct.id = id;
        productsList.add(currentProduct);
      });
      return productsList;
    } catch (e) {
      print('Error trying to retrieve Products');
      return null;
    }
  }

  Future<bool> deleteProduct(String id) async {
    final url = '$_url/products/$id.json';
    try {
      final response = await http.delete(Uri.parse(url));

      if (response.reasonPhrase == "OK") {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error trying to delete');
      return false;
    }
  }

  Future<bool> editProduct(ProductModel product) async {
    final url = '$_url/products/${product.id}.json';

    try {
      final response =
          await http.put(Uri.parse(url), body: productModelToJson(product));

      final decodedData = json.decode(response.body);

      if (decodedData != null) {
        print('Modified');
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error trying to edit');
      return false;
    }
  }
}
