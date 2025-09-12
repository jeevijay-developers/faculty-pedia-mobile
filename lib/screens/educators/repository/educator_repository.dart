import 'dart:convert';
import 'package:facultypedia/models/educator_model.dart';
import 'package:facultypedia/utils/constants.dart';
import 'package:http/http.dart' as http;

class EducatorRepository {
  final String token;

  EducatorRepository({required this.token});

  Future<List<Educator>> getAllEducators() async {
    final url = Uri.parse('$MAIN_URL/educator/all');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final educatorsData = data['educators'] as List;
      return educatorsData.map((e) => Educator.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load educators');
    }
  }
}
