import 'dart:io';

import 'package:chinese_bazaar/domain/entities/category.dart';
import 'package:http/io_client.dart';

import 'dart:convert';

class CategoryApi {
  late String response = "Not connected";
  late String url = "";

  Future<List<Category>> fetchCategories() async {
    // Determine the correct URL based on the platform
    if (Platform.isAndroid || Platform.isIOS) {
      url = "https://192.168.18.199:5001/api/Categories";
    } else if (Platform.isWindows) {
      url = "https://localhost:5001/api/Categories";
    }

    try {
      // Create an HTTP client that ignores certificate errors
      final ioc = HttpClient();
      ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      final http = IOClient(ioc);

      // Perform the GET request
      final result = await http.get(
        Uri.parse("$url/getAll"),
        headers: {'Content-Type': 'application/json'},
      );

      // Check for successful response
      if (result.statusCode >= 200 && result.statusCode <= 299) {
        // Decode the JSON response
        final List<dynamic> jsonResponse = json.decode(result.body);

        // Extract and return category names as a List<String>
    return jsonResponse.map<Category>((category) {
          return Category.fromJson(category); // Convert each JSON object to a Category
        }).toList();
      } else {
        throw Exception("Failed to load categories: ${result.statusCode}");
      }
    } catch (error) {
      // Handle any errors
      return [];
    }
  }
}






