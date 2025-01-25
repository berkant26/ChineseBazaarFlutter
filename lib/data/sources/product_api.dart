import 'dart:convert';
import 'dart:io';
import 'package:chinese_bazaar/domain/entities/product.dart';
import 'package:chinese_bazaar/domain/entities/productImage.dart';
import 'package:http/io_client.dart';
import 'package:logger/logger.dart';

class ProductApi {
  late String productCategoryUrl = "";
  late String productImageUrl = "";
  late String baseUrl = "https://192.168.18.78:5001/api/Products";
var logger = Logger();

  var baseImgUrl = 'http://192.168.18.78:5000/';



Future<List<ProductImage>> fetchProductsImages(int productId) async {
   if (Platform.isAndroid || Platform.isIOS) {
      productImageUrl = "https://192.168.18.78:5001/api/Products/getProductImages?productId=$productId";
    } else if (Platform.isWindows) {
      productImageUrl =  "https://localhost:7037/api/Products/getProductImages?productId=$productId";
    }
 try {
      // Create an HTTP client that ignores certificate errors
      final ioc = HttpClient();
      ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      final http = IOClient(ioc);

      // Perform the GET request
      final response = await http.get(
        Uri.parse(productImageUrl),
        headers: {'Content-Type': 'application/json'},
      );

      // Check for successful response
      if (response.statusCode >= 200 && response.statusCode <= 299) {
        // Decode the JSON response
        final List<dynamic> data = json.decode(response.body);
        logger.d('API Response: $data'); 
        // Map JSON to Product objects and return as a list
        return data.map<ProductImage>((productImage) {
          return ProductImage(
            id: productImage['id'] ?? 0, // Default to 0 if 'id' is null
            productId: productImage['productId']  ?? 0.0, // Default to 0.0 if 'price' is null
            imageUrl: baseImgUrl + productImage['imageUrl'], // Default to an empty string if 'imageUrl' is null
          );
        }).toList();
      } else {
        throw Exception("Failed to load products: ${response.statusCode}");
      }
    } catch (error) {
      // Handle any errors
      return [];
    }
  }





  Future<List<Product>> fetchProductsByCategoryId(int categoryId) async {
    // Determine the correct URL based on the platform
    if (Platform.isAndroid || Platform.isIOS) {
      productCategoryUrl = "https://192.168.18.78:5001/api/Products/getlistbycategoryId?categoryId=$categoryId";
    } else if (Platform.isWindows) {
      productCategoryUrl =  "https://localhost:7037/api/Products/getlistbycategoryId?categoryId=$categoryId";
    }

    try {
      // Create an HTTP client that ignores certificate errors
      final ioc = HttpClient();
      ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      final http = IOClient(ioc);

      // Perform the GET request
      final response = await http.get(
        Uri.parse(productCategoryUrl),
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
           categoryId: product['categoryId'] ?? 1
          );
        }).toList();
      } else {
        throw Exception("Failed to load products: ${response.statusCode}");
      }
    } catch (error) {
      // Handle any errors
      return [];
    }
  }
Future<List<Product>> getAllProducts(int categoryId) async {
    // Determine the correct URL based on the platform
    if (Platform.isAndroid || Platform.isIOS) {
      productCategoryUrl = "https://192.168.18.78:5001/api/Products/getall";
    } else if (Platform.isWindows) {
      productCategoryUrl =  "https://localhost:7037/api/Products/getall";
    }

    try {
      // Create an HTTP client that ignores certificate errors
      final ioc = HttpClient();
      ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      final http = IOClient(ioc);

      // Perform the GET request
      final response = await http.get(
        Uri.parse(productCategoryUrl),
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
           categoryId: product['categoryId'] ?? 1

          );
        }).toList();
      } else {
        throw Exception("Failed to load products: ${response.statusCode}");
      }
    } catch (error) {
      // Handle any errors
      return [];
    }
  }

   Future<bool> addProduct(Product product) async {
    try {
      final ioc = HttpClient();
      ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      final http = IOClient(ioc);
      final response = await http.post(
        Uri.parse("$baseUrl/add"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(product.toJson()),
      );
      return response.statusCode >= 200 && response.statusCode <= 299;
    } catch (error) {
      logger.e("Error adding product: $error");
      return false;
    }
  }

  // Update an existing product
  Future<bool> updateProduct(Product product) async {
    try {
      final ioc = HttpClient();
      ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      final http = IOClient(ioc);
      final response = await http.put(
        Uri.parse("$baseUrl/update"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(product.toJson()),
      );
      return response.statusCode >= 200 && response.statusCode <= 299;
    } catch (error) {
      logger.e("Error updating product: $error");
      return false;
    }
  }

  // Delete a product
  Future<bool> deleteProduct(int productId) async {
    try {
      final ioc = HttpClient();
      ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      final http = IOClient(ioc);
      final response = await http.delete(
        Uri.parse("$baseUrl/delete/$productId"),
        headers: {'Content-Type': 'application/json'},
      );
      return response.statusCode >= 200 && response.statusCode <= 299;
    } catch (error) {
      logger.e("Error deleting product: $error");
      return false;
    }
  }

  fetchCategories() {}
}





