import 'dart:convert';
import 'dart:io';
import 'package:chinese_bazaar/Core/Services/connectionUrl.dart';
import 'package:http/io_client.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthApi {
  
 static final AuthApi _instance = AuthApi._(); // Private named constructor
  factory AuthApi() => _instance; // Singleton instance
  AuthApi._(); // Private constructor to prevent multiple instances

  final logger = Logger();
  late String loginUrl = Connectionurl.userLoginApi;
  late String registerUrl = Connectionurl.userRegisterApi;

  String? username;

  void initialize() {
    // if (Platform.isAndroid || Platform.isIOS) {
    //   loginUrl = "https://192.168.18.199:5001/api/Auth/login";
    //   registerUrl = "https://192.168.18.199:5001/api/Auth/register";

    // } else if (Platform.isWindows) {
    //   loginUrl = "https://localhost:7037/api/Auth/login";
    // }
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
        final responseData = json.decode(response.body);

        // Save token and extract userId
        final token = responseData['token'];
        final userId = _extractUserIdFromToken(token);
        final tokenClaims = _extractClaimsFromToken(token);
        if (tokenClaims != null) {
          final roles = tokenClaims['roles'];

        }
        if (userId != null) {
          await _saveLoginDetails(token, userId);
        } else {
        }

        return responseData;
      } else {
        throw Exception("Login failed: ${response.statusCode}");
      }
    } catch (e) {
      return null;
    }
  }
Future<Map<String, dynamic>?> register(String email, String password) async {
  try {
    final ioc = HttpClient();
    ioc.badCertificateCallback = (cert, host, port) => true;
    final http = IOClient(ioc);

    final response = await http.post(
      Uri.parse(registerUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password, 'firstName': "", 'lastName': ""}),
    );

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      final responseBody = json.decode(response.body);

      // Handle success response with successMessage
      if (responseBody.containsKey('successMessage')) {
        return {"successMessage": responseBody['successMessage']};
      }
    } else {
      final responseBody = json.decode(response.body);

      // Handle error response with message or userAlreadyExist
      if (responseBody.containsKey('message')) {
        return {"message": responseBody['message']};
      } else if (responseBody.containsKey('userAlreadyExist')) {
        return {"userAlreadyExist": responseBody['userAlreadyExist']};
      }

      // If there's no recognized error key, return a general message
      return {"message": "An unexpected error occurred."};
    }
  } catch (e) {
    // Handle any network or other exceptions
    return {"message": "An error occurred: $e"};
  }
  return null;
}






  Future<void> _saveLoginDetails(String token, int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setInt('userId', userId);
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
    } else {
    } 
    // Extract username
    final usernameKey = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name";
    username = payloadMap[usernameKey];
    if (username != null) {
    } else {
    }

    return payloadMap;
  } catch (e) {
    return null;
  }
}
 Future<bool> isAdmin() async {
  final token = await getToken();
  final claims = _extractClaimsFromToken(token!);
  if (claims == null) {
    return false;
  }

  final roleKey = "http://schemas.microsoft.com/ws/2008/06/identity/claims/role";
  final roles = claims[roleKey];

  if (roles is List<dynamic>) {
    return roles.contains('Admin');
  } else {
    return false;
  }
}

Future<bool> canAddProduct() async {
  final token = await getToken();
  if (token == null) {
    return false;
  }

  final claims = _extractClaimsFromToken(token);
  if (claims == null) {
    return false;
  }

  final roleKey = "http://schemas.microsoft.com/ws/2008/06/identity/claims/role";
  final roles = claims[roleKey];

  if (roles is List<dynamic>) {
    final hasAdminRole = roles.contains('Admin');
    final hasProductAddClaim = roles.contains('Product.Add');
    return hasAdminRole && hasProductAddClaim;
  } else {
    return false;
  }
}


  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    return userId;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userId'); // Remove userId
  }
   String? getUserName(){
    return username;
  }
}
