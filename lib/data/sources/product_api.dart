import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:chinese_bazaar/data/sources/login_api.dart';
import 'package:chinese_bazaar/domain/entities/product.dart';
import 'package:chinese_bazaar/domain/entities/productImage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/io_client.dart';
import 'package:http/http.dart' as http;


class ProductAddResult{
   final bool success;
  final int? productId;

  ProductAddResult({required this.success, this.productId});
}


class ProductApi {
  late String productCategoryUrl = "";
  late String productImageUrl = "";
  late String baseUrl = "https://192.168.18.199:5001/api/Products";

  var baseImgUrl = 'http://192.168.18.199:5000/';

Future<ProductAddResult> addProduct(Product product) async {
  if (Platform.isAndroid || Platform.isIOS) {
    baseUrl = "https://192.168.18.199:5001/api/Products/add";
  } else if (Platform.isWindows) {
    baseUrl = "https://localhost:7037/api/Products/add";
  }

  try {
    final token = await AuthApi.getToken();
    if (token == null) {
      return ProductAddResult(success: false);
    }


    final httpClient = HttpClient();
    httpClient.badCertificateCallback = (X509Certificate cert, String host, int port) => true;

    final request = await httpClient.postUrl(Uri.parse(baseUrl));

    // **Set headers with case preservation**
    request.headers.set('Authorization', 'Bearer $token', preserveHeaderCase: true);
    request.headers.set(HttpHeaders.contentTypeHeader, "application/json");

    // **Set request body**
    request.write(jsonEncode(product.toJson()));

    // **Send request and get response**
    final response = await request.close();

    // **Read response body**
    final responseBody = await response.transform(utf8.decoder).join();

    if (response.statusCode >= 200 && response.statusCode <= 299) {
       final Map<String, dynamic> responseData = jsonDecode(responseBody);
      final productId = responseData['productId'];
      return ProductAddResult(success: true,productId: productId);
    } else {
      return ProductAddResult(success: false);
    }
  } catch (e) {
    return ProductAddResult(success: false);
  }
}
Future<bool> uploadProductImages(int productId, List<PlatformFile> selectedImages) async {

  if (Platform.isAndroid || Platform.isIOS) {
    baseUrl = "https://192.168.18.199:5001/api/Products/uploadImages";
  } else if (Platform.isWindows) {
    baseUrl = "https://localhost:7037/api/Products/uploadImages";
  }

  final uri = Uri.parse(baseUrl);
  var request = http.MultipartRequest('POST', uri);

  // **Doğru header ekle**
  request.headers.addAll({
    "Accept": "application/json",
    "Content-Type": "multipart/form-data",
  });

  // **Doğru field ismiyle productId ekle**
  request.fields['productId'] = productId.toString();

  const int maxFileSize = 5 * 1024 * 1024; // 5 MB

  for (var file in selectedImages) {
    if (file.size > maxFileSize) {
      continue;
    }

    if (file.path != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'images', // **Doğru key**
        file.path!,
      ));
    } else if (file.bytes != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'images', // **Doğru key**
        file.bytes!,
        filename: file.name,
      ));
    }
  }

  var response = await request.send();

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
  } 
  
Future<ProductAddResult> updateProduct(int productId, Product product) async {
  
  if (Platform.isAndroid || Platform.isIOS) {
    baseUrl = "https://192.168.18.199:5001/api/Products/update/$productId";
  } else if (Platform.isWindows) {
    baseUrl = "https://localhost:7037/api/Products/update/$productId";
  }

  try {
    final token = await AuthApi.getToken();
    if (token == null) {
      return ProductAddResult(success: false);
    }


    final httpClient = HttpClient();
    httpClient.badCertificateCallback = (X509Certificate cert, String host, int port) => true;

    final request = await httpClient.putUrl(Uri.parse(baseUrl));

    request.headers.set('Authorization', 'Bearer $token', preserveHeaderCase: true);
    request.headers.set(HttpHeaders.contentTypeHeader, "application/json");

    request.write(jsonEncode(product.toJson()));

    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      final Map<String, dynamic> responseData = jsonDecode(responseBody);
      final productId = responseData['productId'];
            return ProductAddResult(success: true, productId: productId);

    } else {
            return ProductAddResult(success: false);

    }
  } catch (e) {
          return ProductAddResult(success: false);

  }
}

Future<bool> updateProductImages(int productId, List<PlatformFile> selectedImages) async {
  
  if (Platform.isAndroid || Platform.isIOS) {
    baseUrl = "https://192.168.18.199:5001/api/Products/updateImages/$productId";
  } else if (Platform.isWindows) {
    baseUrl = "https://localhost:7037/api/Products/updateImages/$productId";
  }

  final uri = Uri.parse(baseUrl);
  var request = http.MultipartRequest('PUT', uri);

  request.headers.addAll({
    "Accept": "application/json",
    "Content-Type": "multipart/form-data",
  });

  const int maxFileSize = 5 * 1024 * 1024; // 5 MB

  for (var file in selectedImages) {
    if (file.size > maxFileSize) {
      continue;
    }

    if (file.path != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'images',
        file.path!,
      ));
    } else if (file.bytes != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'images',
        file.bytes!,
        filename: file.name,
      ));
    }
  }

  var response = await request.send();

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}


Future<List<ProductImage>> fetchProductsImages(int productId) async {
   if (Platform.isAndroid || Platform.isIOS) {
      productImageUrl = "https://192.168.18.199:5001/api/Products/getProductImages?productId=$productId";
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
      productCategoryUrl = "https://192.168.18.199:5001/api/Products/getlistbycategoryId?categoryId=$categoryId";
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
           categoryId: product['categoryId'] ?? 1,
           stockAmount: product['stockAmount'] ?? 1,
           description:  product['description'] ?? ''
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
Future<List<Product>> fetchAllProducts() async {
    // Determine the correct URL based on the platform
    if(Platform.isAndroid || Platform.isIOS)
  {
    baseUrl = "https://192.168.18.199:5001/api/Products/getall";
  }
  else if(Platform.isWindows)
  {
    baseUrl = "https://192.168.18.199:5001/api/Products/getall";

  }

    try {
      // Create an HTTP client that ignores certificate errors
      final ioc = HttpClient();
      ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      final http = IOClient(ioc);

      // Perform the GET request
      final response = await http.get(
        Uri.parse(baseUrl),
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
           categoryId: product['categoryId'] ?? 1,
           stockAmount: product['stockAmount'] ?? 1,
           description:  product['description'] ?? ''

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

  

  // Update an existing product
  
  Future<bool> deleteProductImage(List<ProductImage> productImage) async {

  try {
    final ioc = HttpClient();
    ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;

    final request = await ioc.postUrl(
      Uri.parse("$baseUrl/deleteProductImage"),
    );

    request.headers.set('Content-Type', 'application/json');
    request.write(jsonEncode(productImage));
    final response = await request.close();

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      return true;
    } else {
      return false;
    }
  } catch (error) {
    return false;
  }
}

 
  // Delete a product
  Future<bool> deleteProduct(Product product) async {
    try {
      final ioc = HttpClient();
      ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      final httpClient = HttpClient();

      final requiest = await ioc.postUrl(
        Uri.parse("$baseUrl/delete"),     
      );

      requiest.headers.set('Content-Type', 'application/json');
      requiest.write(jsonEncode(product));
      final response = await requiest.close();

      return response.statusCode >= 200 && response.statusCode <= 299;
    } catch (error) {
      return false;
    }
  }
   
}





