import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:facultypedia/utils/constants.dart';

class ProfileRepository {
  final String baseUrl = MAIN_URL;

  // NEW: only send changed fields
  Future<Map<String, dynamic>> updateProfilePartial({
    required String token,
    required String userId,
    required Map<String, String> fields,
  }) async {
    final url = Uri.parse("$baseUrl/update/student/email-name-mobile/$userId");

    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(fields),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(response.body);
    }
  }
}