import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/course_model.dart';

class CourseRepository {
  final String baseUrl = "http://localhost:5000/api/courses";

  Future<List<Course>> fetchCourses() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Course.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load courses");
    }
  }

  Future<Course> fetchCourseById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      return Course.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load course");
    }
  }
}