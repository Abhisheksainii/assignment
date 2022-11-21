import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:assignment/modal/product_model.dart';

class API {
  Future<List<Product>> getProducts() async {
    final response = await http.get(
      Uri.parse("https://fakestoreapi.com/products"),
    );
    if (response.statusCode == 200) {
      print(response.body);
      return List<Product>.from(
          jsonDecode(response.body).map((item) => Product.fromJSON(item)));
    } else {
      print(response.statusCode);
      throw Exception('Failed to get all reports ${response.statusCode}');
    }
  }
}
