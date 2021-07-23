import 'dart:convert';
import 'package:global_inv/src/objects/saleModel.dart';
import 'package:http/http.dart' as http;

class SalesProvider {
  final String _url = 'https://global-inv-default-rtdb.firebaseio.com';

  Future<bool> createSale(SaleModel sale) async {
    final url = '$_url/sales.json';

    sale.date = new DateTime.now();

    try {
      final response =
          await http.post(Uri.parse(url), body: saleModelToJson(sale));
      final decodedData = json.decode(response.body);
      if (decodedData != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error trying to add a new sale');
      return false;
    }
  }

  Future<List<SaleModel>> readSales() async {
    final url = '$_url/sales.json';
    try {
      final response = await http.get(Uri.parse(url));
      final Map<String, dynamic> decodedData = json.decode(response.body);
      final List<SaleModel> saleList = [];

      if (decodedData == null) return [];

      decodedData.forEach((id, product) {
        final currentSale = SaleModel.fromJson(product);
        currentSale.id = id;
        saleList.add(currentSale);
      });
      return saleList;
    } catch (e) {
      print('Error trying to retrieve sales');
      return null;
    }
  }

  Future<bool> deleteSale(String id) async {
    final url = '$_url/sales/$id.json';
    try {
      final response = await http.delete(Uri.parse(url));

      if (response.reasonPhrase == "OK") {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error trying to delete a sale');
      return false;
    }
  }

  Future<bool> editProduct(SaleModel sale) async {
    final url = '$_url/sales/${sale.id}.json';

    sale.date = new DateTime.now();

    try {
      final response =
          await http.put(Uri.parse(url), body: saleModelToJson(sale));

      final decodedData = json.decode(response.body);

      if (decodedData != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error trying to edit a sale');
      return false;
    }
  }
}
