

import 'dart:convert';
import 'dart:io';

import 'package:chinese_bazaar/domain/entities/Order.dart';

class OrderApi {
  late String baseUrl = "https://192.168.18.199:5001/api/Order";

  Future<Map<String, dynamic>?> fetchOrders(int userId) async {
  final httpClient = HttpClient();
  httpClient.badCertificateCallback = (X509Certificate cert, String host, int port) => true;

  final uri = Uri.parse('$baseUrl/getUserOrders?userId=$userId');
  final request = await httpClient.getUrl(uri);

  // Set Content-Type header if necessary
  request.headers.set(HttpHeaders.contentTypeHeader, "application/json");

  try {
    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      print('Response Body: $responseBody');  // Log API response

      final Map<String, dynamic> responseData = jsonDecode(responseBody);

      if (responseData == null) {
        throw Exception('API returned null');
      }

      return responseData;
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
    throw Exception('Failed to create order: ${response}');
  }
}

}
