import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:chinese_bazaar/Core/Services/connectionUrl.dart';
import 'package:chinese_bazaar/data/sources/login_api.dart';
import 'package:chinese_bazaar/domain/entities/product.dart';
import 'package:chinese_bazaar/domain/entities/productImage.dart';
import 'package:http/io_client.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';


class ProductAddResult{
   final bool success;
  final int? productId;

  ProductAddResult({required this.success, this.productId});
}


class ProductApi {
  late String productAddUrl = Connectionurl.productAddApi;
  late String productUpdateUrl = Connectionurl.updateProductApi;
  late String fetchProductImagesUrl = Connectionurl.fetchProductImagesApi;
  late String uploadProductImagesUrl = Connectionurl.productUploadImagesApi;
  late String fetchAllProductsUrl = Connectionurl.fetchAllProductsApi;
  late String deleteProductImagesUrl = Connectionurl.deleteProductImagesApi;
  late String fetchProductCategoryByIdUrl = Connectionurl.fetchProductCategoryByIdApi;
   late String deleteProductUrl = Connectionurl.deleteProductApi;
  var baseImgUrl = Connectionurl.baseImgUrl;



Future<ProductAddResult> addProduct(Product product) async {

  try {
    final token = await AuthApi.getToken();
    if (token == null) {
      return ProductAddResult(success: false);
    }


    final httpClient = HttpClient();
    httpClient.badCertificateCallback = (X509Certificate cert, String host, int port) => true;

    final request = await httpClient.postUrl(Uri.parse(productAddUrl));

    // **Set headers with case preservation**
    request.headers.set('Authorization', 'Bearer $token', preserveHeaderCase: true);
    request.headers.set(HttpHeaders.contentTypeHeader, "application/json");

    // **Set request body**
    request.write(jsonEncode(product.toJson()));

    final response = await request.close();

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
Future<bool> uploadProductImages(int productId, List<XFile> selectedImages) async {
  final uri = Uri.parse(uploadProductImagesUrl);
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
    int fileSize = await File(file.path).length(); // ✅ Doğru dosya boyutu kontrolü

    if (fileSize > maxFileSize) {
      continue; // Büyük dosyaları atla
    }

    request.files.add(await http.MultipartFile.fromPath(
      'images', // **Doğru key**
      file.path,
    ));
  }

  try {
    var response = await request.send();

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}
  
Future<ProductAddResult> updateProduct(int productId, Product product) async {
  

    // productUpdateUrl = productUpdateUrl+"/$productId";
final String productUpdateUrlWithId = "$productUpdateUrl/$productId";
  try {
    final token = await AuthApi.getToken();
    if (token == null) {
      return ProductAddResult(success: false);
    }


    final httpClient = HttpClient();
    httpClient.badCertificateCallback = (X509Certificate cert, String host, int port) => true;

    final request = await httpClient.putUrl(Uri.parse(productUpdateUrlWithId));

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

Future<bool> updateProductImages(int productId, List<XFile> selectedImages) async {
  final String updateProductImagesApi = "${Connectionurl.updateProductImagesApi}/$productId";
  final uri = Uri.parse(updateProductImagesApi);
  var request = http.MultipartRequest('PUT', uri);

  request.headers.addAll({
    "Accept": "application/json",
    "Content-Type": "multipart/form-data",
  });

  const int maxFileSize = 5 * 1024 * 1024; // 5 MB

  for (var file in selectedImages) {
    int fileSize = await File(file.path).length(); // ✅ Doğru dosya boyutu kontrolü

    if (fileSize > maxFileSize) {
      continue; // Büyük dosyaları atla
    }

    request.files.add(await http.MultipartFile.fromPath(
      'images', // **Doğru key**
      file.path,
    ));
  }

  try {
    var response = await request.send();
    return response.statusCode == 200;
  } catch (e) {
    return false;
  }
}


Future<List<ProductImage>> fetchProductsImages(int productId) async {
 
    final url = "$fetchProductImagesUrl$productId";
    Logger log = Logger();
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
        return data.map<ProductImage>((productImage) {
          return ProductImage(
            id: productImage['id'] ?? 0, // Default to 0 if 'id' is null
            productId: productImage['productId']  ?? 0.0, // Default to 0.0 if 'price' is null
            imageUrl: productImage['imageUrl'], // Default to an empty string if 'imageUrl' is null
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
    
     fetchProductCategoryByIdUrl = "$fetchProductCategoryByIdUrl$categoryId";
    try {
      // Create an HTTP client that ignores certificate errors
      final ioc = HttpClient();
      ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      final http = IOClient(ioc);

      // Perform the GET request
      final response = await http.get(
        Uri.parse(fetchProductCategoryByIdUrl),
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
    

    try {
      // Create an HTTP client that ignores certificate errors
      final ioc = HttpClient();
      ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      final http = IOClient(ioc);

      // Perform the GET request
      final response = await http.get(
        Uri.parse(fetchAllProductsUrl),
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
      Uri.parse(deleteProductImagesUrl),
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

      final requiest = await ioc.postUrl(
        Uri.parse(deleteProductUrl),     
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





