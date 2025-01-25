import 'dart:convert';
import 'dart:io';

import 'package:http/io_client.dart';
import 'package:logger/logger.dart';

class AddressApi {
  final logger = Logger();
  late String baseUrl;

  AddressApi() {
    if (Platform.isAndroid || Platform.isIOS) {
      baseUrl = "https://192.168.18.78:5001/api";  // Replace with your server IP
    } else if (Platform.isWindows) {
      baseUrl = "https://localhost:7037/api";  // Replace with your server IP
    }
  }

  // Fetch Cities without Cache
  Future<List<Map<String, dynamic>>> getCities() async {
    try {
      final ioc = HttpClient();
      ioc.badCertificateCallback = (cert, host, port) => true;
      final http = IOClient(ioc);

      final response = await http.get(
        Uri.parse("$baseUrl/Address/getCities"),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        logger.d('Cities fetched successfully: ${response.body}');
        final responseData = json.decode(response.body);
        return List<Map<String, dynamic>>.from(responseData);
      } else {
        logger.e('Failed to fetch cities: ${response.body}');
        throw Exception("Failed to fetch cities: ${response.statusCode}");
      }
    } catch (e) {
      logger.e("Error: $e");
      return [];
    }
  }

  // Fetch Districts by City ID without Cache
  Future<List<Map<String, dynamic>>> getDistricts(int cityId) async {
    try {
      final ioc = HttpClient();
      ioc.badCertificateCallback = (cert, host, port) => true;
      final http = IOClient(ioc);

      final response = await http.get(
        Uri.parse("$baseUrl/Address/districts/$cityId"),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        logger.d('Districts fetched successfully: ${response.body}');
        final responseData = json.decode(response.body);
        return List<Map<String, dynamic>>.from(responseData);
      } else {
        logger.e('Failed to fetch districts: ${response.body}');
        throw Exception("Failed to fetch districts: ${response.statusCode}");
      }
    } catch (e) {
      logger.e("Error: $e");
      return [];
    }
  }

  // Fetch Neighborhoods by District ID without Cache
  Future<List<Map<String, dynamic>>> getNeighborhoods(int districtId) async {
    try {
      final ioc = HttpClient();
      ioc.badCertificateCallback = (cert, host, port) => true;
      final http = IOClient(ioc);

      final response = await http.get(
        Uri.parse("$baseUrl/Address/neighborhoods/$districtId"),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode >= 200 && response.statusCode <= 299) {
        logger.d('Neighborhoods fetched successfully: ${response.body}');
        final responseData = json.decode(response.body);
        return List<Map<String, dynamic>>.from(responseData);
      } else {
        logger.e('Failed to fetch neighborhoods: ${response.body}');
        throw Exception("Failed to fetch neighborhoods: ${response.statusCode}");
      }
    } catch (e) {
      logger.e("Error: $e");
      return [];
    }
  }
  Future<bool> saveUserAddress(Map<String, dynamic> userAddress) async {

    
  try {
    final ioc = HttpClient();
    ioc.badCertificateCallback = (cert, host, port) => true;
    final http = IOClient(ioc);

    final response = await http.post(
      Uri.parse("$baseUrl/Address/saveUserAddress"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(userAddress),
    );

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      logger.d('Kayıt başarılı: ${response.body}');
      return true;
    } else {
      logger.e('Kayıt başarısız: ${response.body}');
      return false;
    }
  } catch (e) {
    logger.e("Error saving user address: $e");
    return false;
  }



}
Future<bool> updateUserAddress(Map<String, dynamic> userAddress) async {
  try {
    final ioc = HttpClient();
    ioc.badCertificateCallback = (cert, host, port) => true;
    final http = IOClient(ioc);

    final response = await http.put(
      Uri.parse("$baseUrl/Address/updateUserAddress"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(userAddress),
    );

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      logger.d("User address updated successfully: ${response.body}");
      return true;
    } else {
      logger.e("Failed to update user address: ${response.body}");
      return false;
    }
  } catch (e) {
    logger.e("Error updating user address: $e");
    return false;
  }
}




Future<Map<String, dynamic>?> getUserAddress(int? userId) async {
  try {
    final ioc = HttpClient();
    ioc.badCertificateCallback = (cert, host, port) => true;
    final http = IOClient(ioc);

    final response = await http.get(
      Uri.parse("$baseUrl/Address/getUserAddress/$userId"),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode >= 200 && response.statusCode <= 299) {
      logger.d("User address fetched successfully: ${response.body}");
      return json.decode(response.body);
    } else {
      logger.e("Failed to fetch user address: ${response.body}");
      return null;
    }
  } catch (e) {
    logger.e("Error fetching user address: $e");
    return null;
  }
}



}