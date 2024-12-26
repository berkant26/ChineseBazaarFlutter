import 'dart:convert';
import 'package:chinese_bazaar/domain/entities/product.dart';
import 'package:http/http.dart' as http;

class ProductApi {
  Future<List<Product>> fetchProductsByCategory(String category) async {
    final url = Uri.parse('https://localhost:7037/api/Products?category=$category');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((product) {
        return Product(
          id: product['id'],
          name: product['name'],
          price: product['price'],
          imageUrl: product['imageUrl'],
        );
      }).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}