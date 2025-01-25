import 'dart:convert';
import 'dart:io';
import 'package:http/io_client.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthApi {
  final logger = Logger();
  late String loginUrl;

  AuthApi() {
    if (Platform.isAndroid || Platform.isIOS) {
      loginUrl = "https://192.168.18.78:5001/api/Auth/login";
    } else if (Platform.isWindows) {
      loginUrl = "https://localhost:7037/api/Auth/login";
    }
  }

  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final ioc = HttpClient();
      ioc.badCertificateCallback = (cert, host, port) => true;
      final http = IOClient(ioc);

      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        logger.d('Login Successful: ${response.body}');
        final responseData = json.decode(response.body);

        // Save token and extract userId
        final token = responseData['token'];
        final userId = _extractUserIdFromToken(token);
        final tokenClaims = _extractClaimsFromToken(token);
        if (tokenClaims != null) {
          final roles = tokenClaims['roles'];
          logger.d("User roles: $roles");

        }
        if (userId != null) {
          await _saveLoginDetails(token, userId);
          logger.d("UserId extracted and saved: $userId");
        } else {
          logger.e("Failed to extract userId from token.");
        }

        return responseData;
      } else {
        logger.e('Login Failed: ${response.body}');
        throw Exception("Login failed: ${response.statusCode}");
      }
    } catch (e) {
      logger.e("Error: $e");
      return null;
    }
  }

  Future<void> _saveLoginDetails(String token, int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setInt('userId', userId);
    logger.d("Login details saved: token=$token, userId=$userId");
  }

 

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

Map<String, dynamic>? _extractClaimsFromToken(String token) {
  try {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception("Invalid token format");
    }

    // Decode payload (second part of the token)
    final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
    final payloadMap = json.decode(payload);

    // Extract claims and roles
    final roleKey = "http://schemas.microsoft.com/ws/2008/06/identity/claims/role";
    final roles = payloadMap[roleKey];

    if (roles is List<dynamic>) {
      logger.d("Extracted roles: $roles");
    } else {
      logger.e("Roles field is not a list in the token payload.");
    }

    return payloadMap;
  } catch (e) {
    logger.e("Failed to extract claims from token: $e");
    return null;
  }
}
 bool isAdmin(String token) {
  final claims = _extractClaimsFromToken(token);
  if (claims == null) {
    logger.e("Failed to extract claims for isAdmin check.");
    return false;
  }

  final roleKey = "http://schemas.microsoft.com/ws/2008/06/identity/claims/role";
  final roles = claims[roleKey];

  if (roles is List<dynamic>) {
    logger.d("User roles: $roles");
    return roles.contains('Admin');
  } else {
    logger.e("Roles field is missing or not a list in the token payload.");
    return false;
  }
}

Future<bool> canAddProduct() async {
  final token = await getToken();
  if (token == null) {
    logger.e("Token is null in canAddProduct.");
    return false;
  }

  final claims = _extractClaimsFromToken(token);
  if (claims == null) {
    logger.e("Failed to extract claims for canAddProduct check.");
    return false;
  }

  final roleKey = "http://schemas.microsoft.com/ws/2008/06/identity/claims/role";
  final roles = claims[roleKey];

  if (roles is List<dynamic>) {
    final hasAdminRole = roles.contains('Admin');
    final hasProductAddClaim = roles.contains('Product.Add');
    logger.d("User has admin role: $hasAdminRole, has Product.Add claim: $hasProductAddClaim");
    return hasAdminRole && hasProductAddClaim;
  } else {
    logger.e("Roles field is missing or not a list in the token payload.");
    return false;
  }
}


  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    logger.d("Retrieved userId from SharedPreferences: $userId");
    return userId;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userId'); // Remove userId
    logger.d("Token and userId removed from SharedPreferences");
  }
}
