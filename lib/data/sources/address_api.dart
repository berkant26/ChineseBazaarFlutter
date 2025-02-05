import 'dart:convert';
import 'dart:io';

import 'package:http/io_client.dart';
import 'package:logger/logger.dart';

class AddressApi {
  final logger = Logger();
  late String baseUrl;

  AddressApi() {
    if (Platform.isAndroid || Platform.isIOS) {
      baseUrl = "https://192.168.18.199:5001/api";  // Replace with your server IP
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
        final responseData = json.decode(response.body);
        return List<Map<String, dynamic>>.from(responseData);
      } else {
        throw Exception("Failed to fetch cities: ${response.statusCode}");
      }
    } catch (e) {
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
        final responseData = json.decode(response.body);
        return List<Map<String, dynamic>>.from(responseData);
      } else {
        throw Exception("Failed to fetch districts: ${response.statusCode}");
      }
    } catch (e) {
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
        final responseData = json.decode(response.body);
        return List<Map<String, dynamic>>.from(responseData);
      } else {
        throw Exception("Failed to fetch neighborhoods: ${response.statusCode}");
      }
    } catch (e) {
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
      return true;
    } else {
      return false;
    }
  } catch (e) {
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
      return true;
    } else {
      return false;
    }
  } catch (e) {
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
      return json.decode(response.body);
    } else {
      return null;
    }
  } catch (e) {
    return null;
  }
}



}