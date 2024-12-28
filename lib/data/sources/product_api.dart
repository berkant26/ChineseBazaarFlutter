import 'dart:convert';
import 'dart:io';
import 'package:chinese_bazaar/domain/entities/product.dart';
import 'package:http/io_client.dart';

class ProductApi {
  late String url = "";

  Future<List<Product>> fetchProductsByCategory(String category) async {
    // Determine the correct URL based on the platform
    if (Platform.isAndroid || Platform.isIOS) {
      url = "https://192.168.18.78:5001/api/Products?category=$category";
    } else if (Platform.isWindows) {
      url = "https://localhost:7037/api/Products?category=$category";
    }

    try {
      // Create an HTTP client that ignores certificate errors
      final ioc = HttpClient();
      ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      final http = IOClient(ioc);

      // Perform the GET request
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      // Check for successful response
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        // Decode the JSON response
        final List<dynamic> data = json.decode(response.body);

        // Map JSON to Product objects and return as a list
        return data.map<Product>((product) {
          return Product(
            id: product['id'],
            name: product['name'],
            price: (product['price'] as num).toDouble(),
            imageUrl: product['imageUrl'],
          );
        }).toList();
      } else {
        throw Exception("Failed to load products: ${response.statusCode}");
      }
    } catch (error) {
      // Handle any errors
      print("Error: $error");
      return [];
    }
  }
}