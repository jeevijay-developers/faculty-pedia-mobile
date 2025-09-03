import 'dart:convert';
import 'package:facultypedia/models/blog_model.dart';
import 'package:facultypedia/utils/constants.dart';
import 'package:http/http.dart' as http;

class BlogRepository {
  final String token;

  BlogRepository({required this.token});

  Future<List<Blog>> getAllBlogs() async {
    final url = Uri.parse('$MAIN_URL/blog/get-all-blogs');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['blogs'] as List;
      return data.map((e) => Blog.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load blogs');
    }
  }
}
