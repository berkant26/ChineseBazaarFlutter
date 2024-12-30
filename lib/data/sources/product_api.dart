import 'dart:convert';
import 'dart:io';
import 'package:chinese_bazaar/domain/entities/product.dart';
import 'package:http/io_client.dart';

class ProductApi {
  late String url = "";

  Future<List<Product>> fetchProductsByCategoryId(int categoryId) async {
    // Determine the correct URL based on the platform
    if (Platform.isAndroid || Platform.isIOS) {
      url = "https://192.168.18.78:5001/api/Products/getlistbycategoryId?categoryId=$categoryId";
    } else if (Platform.isWindows) {
      url =  "https://localhost:7037/api/Products/getlistbycategoryId?categoryId=$categoryId";
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
            id: product['id'] ?? 0, // Default to 0 if 'id' is null
            name: product['name'] ?? 'Unknown', // Default to 'Unknown' if 'name' is null
            price: (product['price'] as num?)?.toDouble() ?? 0.0, // Default to 0.0 if 'price' is null
            imageUrl: product['imageUrl'] ?? '', // Default to an empty string if 'imageUrl' is null
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