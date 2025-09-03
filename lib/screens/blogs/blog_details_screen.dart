import 'package:facultypedia/models/blog_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class BlogDetailScreen extends StatelessWidget {
  final Blog blog;

  const BlogDetailScreen({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(blog.title),
        backgroundColor: const Color(0xFF4A90E2),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (blog.imageUrl.isNotEmpty)
                Image.network(blog.imageUrl, width: double.infinity, fit: BoxFit.cover),
              const SizedBox(height: 16),
              Html(data: blog.longContent),
            ],
          ),
        ),
      ),
    );
  }
}