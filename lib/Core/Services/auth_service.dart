import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart'; // Optional if you still want to use it
import 'package:logger/logger.dart';



class AuthService {
  final logger = Logger();

  // Save the token to SharedPreferences
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  // Get the token from SharedPreferences
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Logout the user by removing the token
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  // Decode JWT and extract the userId from the 'nameidentifier' claim
  int? _extractUserIdFromToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        throw Exception("Invalid token format");
      }

      // Decode payload (second part of the token)
      final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
      final payloadMap = json.decode(payload);

      // Extract userId using the full claim key
      final nameIdentifierKey = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier";
      if (payloadMap.containsKey(nameIdentifierKey)) {
        return int.parse(payloadMap[nameIdentifierKey]);
      } else {
        throw Exception("nameid field is missing in token payload.");
      }
    } catch (e) {
      logger.e("Failed to extract userId from token: $e");
      return null;
    }
  }

  // Extract roles from the token
  

  // Check if the token is valid (not expired)
  Future<bool> isTokenValid() async {
    final token = await getToken();
    if (token == null || JwtDecoder.isExpired(token)) {
      return false;
    }
    return true;
  }

 

  // Check if the user is authorized to add a product
  
}
