

import 'dart:convert';
import 'dart:io';

import 'package:chinese_bazaar/Core/Services/connectionUrl.dart';
import 'package:chinese_bazaar/domain/entities/Order.dart';

class OrderApi {
  late String baseUrl = Connectionurl.orderApi;
 Future<List<Map<String, dynamic>>?> fetchUserOrders(int userId) async {
  final httpClient = HttpClient();
  httpClient.badCertificateCallback = (X509Certificate cert, String host, int port) => true;

  final uri = Uri.parse('$baseUrl/getUserOrders?userId=$userId');
  final request = await httpClient.getUrl(uri);
  request.headers.set(HttpHeaders.contentTypeHeader, "application/json");

  try {
    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      print('Response Body: $responseBody');  // Log API response

      final List<dynamic> responseData = jsonDecode(responseBody);

      if (responseData.isEmpty) {
        throw Exception('API returned empty list');
      }

      return responseData.cast<Map<String, dynamic>>(); // Convert to List<Map<String, dynamic>>
    } else {
      throw Exception('Failed to load orders: $responseBody');
    }
  } catch (e) {
    print('Error fetching orders: $e');
    throw Exception('Error fetching orders: $e');
  }
}
Future<List<Map<String, dynamic>>?> fetchAllOrders() async {
  final httpClient = HttpClient();
  httpClient.badCertificateCallback = (X509Certificate cert, String host, int port) => true;

  final uri = Uri.parse('$baseUrl/getAllOrders');
  final request = await httpClient.getUrl(uri);
  request.headers.set(HttpHeaders.contentTypeHeader, "application/json");

  try {
    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      print('Response Body: $responseBody');  // Log API response

      final List<dynamic> responseData = jsonDecode(responseBody);

      if (responseData.isEmpty) {
        throw Exception('API returned empty list');
      }

      return responseData.cast<Map<String, dynamic>>(); // Convert to List<Map<String, dynamic>>
    } else {
      throw Exception('Failed to load orders: $responseBody');
    }
  } catch (e) {
    print('Error fetching orders: $e');
    throw Exception('Error fetching orders: $e');
  }
}


  Future<void> addOrder(OrderRequestDto orderRequest) async {
  final httpClient = HttpClient();
  final url = Uri.parse('$baseUrl/addUserOrder');
  final request = await httpClient.postUrl(url);
    request.headers.set(HttpHeaders.contentTypeHeader, "application/json");
  request.write(jsonEncode(orderRequest));

  final response = await request.close();

  final responseBody = await response.transform(utf8.decoder).join();
  
  

  if (response.statusCode >= 200 && response.statusCode <= 299) {
    print('Order created successfully.');
  } else {
    throw Exception('Failed to create order: $response');
  }
}

}
