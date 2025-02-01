import 'dart:io';
import 'dart:convert';




class HttpHelper {
  static final HttpClient _httpClient = HttpClient()
    ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;

  /// Sends a POST request with optional authentication
  static Future<Map<String, dynamic>?> post({
    required String url,
    required Map<String, dynamic> body,
    String? token,
    Map<String, String>? headers,
  }) async {
    try {
      final request = await _httpClient.postUrl(Uri.parse(url));

      // Set headers (preserving case)
      headers?.forEach((key, value) {
        request.headers.set(key, value, preserveHeaderCase: true);
      });

      if (token != null) {
        request.headers.set('Authorization', 'Bearer $token', preserveHeaderCase: true);
      }

      request.headers.set(HttpHeaders.contentTypeHeader, "application/json");

      // Set request body
      request.write(jsonEncode(body));

      // Send request and get response
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      // ✅ Return both status code and JSON body
      return {
        'statusCode': response.statusCode,
        'body': responseBody.isNotEmpty ? jsonDecode(responseBody) : null,
      };
    } catch (e) {
      print("HTTP Request Error: $e");
      return null;
    }
  }
}
