import 'dart:convert';
import 'package:facultypedia/utils/constants.dart';
import 'package:http/http.dart' as http;

class AuthRepository {
  final String baseUrl = MAIN_URL; // emulator Android

  Future<Map<String, dynamic>> signup({
    required String email,
    required String mobileNumber,
    required String name,
    required String password,
  }) async {
    final url = Uri.parse("$baseUrl/auth/signup-student");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "mobileNumber": mobileNumber,
        "name": name,
        "password": password,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse("$baseUrl/auth/login-student");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(response.body);
    }
  }
}
