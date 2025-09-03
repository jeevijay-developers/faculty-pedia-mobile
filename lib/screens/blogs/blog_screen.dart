import 'package:facultypedia/components/custom_drawer.dart';
import 'package:facultypedia/screens/blogs/bloc/blog_bloc.dart';
import 'package:facultypedia/screens/blogs/bloc/blog_event.dart';
import 'package:facultypedia/screens/blogs/bloc/blog_state.dart';
import 'package:facultypedia/screens/blogs/blog_details_screen.dart';
import 'package:facultypedia/screens/blogs/repository/blog_repository.dart';
import 'package:facultypedia/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BlogScreen extends StatelessWidget {
  const BlogScreen({super.key});

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token") ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return FutureBuilder<String>(
      future: _getToken(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        final repository = BlogRepository(token: snapshot.data!);

        return BlocProvider(
          create: (context) =>
              BlogBloc(repository: repository)..add(FetchBlogs()),
          child: Scaffold(
            drawer: const CustomDrawer(),
            key: scaffoldKey,
            appBar: AppBar(
              title: const Text("Blogs"),
              backgroundColor: const Color(0xFF4A90E2),
              leading: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  scaffoldKey.currentState?.openDrawer();
                },
              ),
            ),
            body: BlocBuilder<BlogBloc, BlogState>(
              builder: (context, state) {
                if (state is BlogLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is BlogLoaded) {
                  final blogs = state.blogs;
                  if (blogs.isEmpty) {
                    return const Center(child: Text("No blogs available"));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: blogs.length,
                    itemBuilder: (context, index) {
                      final blog = blogs[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlogDetailScreen(blog: blog),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (blog.imageUrl.isNotEmpty)
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(16),
                                  ),
                                  child: buildBlogImage(blog.imageUrl),
                                ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      blog.title,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      blog.shortContent,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is BlogError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox();
              },
            ),
          ),
        );
      },
    );
  }

  Widget buildBlogImage(String imageUrl) {
    final String url = imageUrl.startsWith("http")
        ? imageUrl
        : "$MAIN_URL/$imageUrl";

    // Basic check for SVG URL
    if (!url.toLowerCase().endsWith(".svg")) {
      // Treat as normal image
      return Image.network(
        url,
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          height: 180,
          color: Colors.grey[200],
          child: const Icon(Icons.broken_image),
        ),
      );
    }

    return SvgPicture.network(
      url,
      height: 180,
      width: double.infinity,
      fit: BoxFit.cover,
      placeholderBuilder: (context) => Container(
        height: 180,
        color: Colors.grey[200],
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
