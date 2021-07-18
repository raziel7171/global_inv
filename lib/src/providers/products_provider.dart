import 'dart:convert';
import 'package:global_inv/src/objects/productModel.dart';
import 'package:http/http.dart' as http;

class ProductsProvider {
  final String _url = 'https://global-inv-default-rtdb.firebaseio.com';

  Future<bool> createProduct(ProductModel product) async {
    final url = '$_url/products.json';
    final response =
        await http.post(Uri.parse(url), body: productModelToJson(product));

    final decodedData = json.decode(response.body);

    print(decodedData);
    return true;
  }

  Future<List<ProductModel>> readProducts() async {
    final url = '$_url/products.json';
    final response = await http.get(Uri.parse(url));

    final Map<String, dynamic> decodedData = json.decode(response.body);
    final List<ProductModel> productsList = [];

    if (decodedData == null) return [];

    decodedData.forEach((id, product) {
      final currentProduct = ProductModel.fromJson(product);
      currentProduct.code = id;
      productsList.add(currentProduct);
    });

    print(productsList);
    return productsList;
  }
}
