import 'package:http/http.dart' as http;
import 'dart:convert';

class CategoryApi {
  Future<List<String>> fetchCategories() async {
    final url = Uri.parse('http://192.168.18.78:3000/Categories');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((category) => category['name'] as String).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }
}