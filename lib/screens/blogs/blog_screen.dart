import 'package:facultypedia/screens/blogs/bloc/blog_bloc.dart';
import 'package:facultypedia/screens/blogs/bloc/blog_event.dart';
import 'package:facultypedia/screens/blogs/bloc/blog_state.dart';
import 'package:facultypedia/screens/blogs/blog_details_screen.dart';
import 'package:facultypedia/screens/blogs/repository/blog_repository.dart';
import 'package:facultypedia/models/blog_model.dart';
import 'package:facultypedia/utils/constants.dart';
import 'package:facultypedia/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

const Color kPrimaryColor = Color(0xFF4A90E2);

class BlogScreen extends StatefulWidget {
  const BlogScreen({super.key});

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> with TickerProviderStateMixin {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final GlobalKey<RefreshIndicatorState> _refreshKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      if (_isSearchExpanded) {
        _animationController.reverse();
        _searchController.clear();
        _searchQuery = '';
      } else {
        _animationController.forward();
      }
      _isSearchExpanded = !_isSearchExpanded;
    });
  }

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token") ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FutureBuilder<String>(
      future: _getToken(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
              ),
            ),
          );
        }

        final repository = BlogRepository(token: snapshot.data!);

        return BlocProvider(
          create: (context) =>
              BlogBloc(repository: repository)..add(FetchBlogs()),
          child: Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            appBar: AppBar(
              backgroundColor: theme.appBarTheme.backgroundColor,
              elevation: 0,
              leading: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.arrow_back,
                    color: theme.colorScheme.primary,
                    size: 16,
                  ),
                ),
                onPressed: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.pop(context);
                  } else {
                    Navigator.pushReplacementNamed(context, AppRouter.home);
                  }
                },
              ),
              title: _isSearchExpanded
                  ? FadeTransition(
                      opacity: _fadeAnimation,
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: 'Search educational articles...',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: theme.dividerColor),
                        ),
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontSize: 16,
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value.toLowerCase();
                          });
                        },
                      ),
                    )
                  : SizedBox(
                      height: 40,
                      child: Image.asset("assets/images/fp.png"),
                    ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _isSearchExpanded ? Icons.close : Icons.search,
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                  ),
                  onPressed: _toggleSearch,
                ),
                const SizedBox(width: 8),
              ],
            ),
            body: RefreshIndicator(
              key: _refreshKey,
              onRefresh: () async {
                context.read<BlogBloc>().add(FetchBlogs());
              },
              child: Column(
                children: [
                  // Hero Section
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          theme.cardColor,
                          theme.colorScheme.primary.withOpacity(0.05),
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                      child: Column(
                        children: [
                          Text(
                            "📚 Educational Blogs",
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Discover insights, tips, and knowledge from expert educators",
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontSize: 16,
                              color: theme.dividerColor,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Content Section
                  Expanded(
                    child: BlocBuilder<BlogBloc, BlogState>(
                      builder: (context, state) {
                        if (state is BlogLoading) {
                          return Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                theme.colorScheme.primary,
                              ),
                            ),
                          );
                        } else if (state is BlogLoaded) {
                          final blogs = state.blogs;
                          if (blogs.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primary
                                          .withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.article_outlined,
                                      size: 60,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                  const SizedBox(height: 32),
                                  Text(
                                    "No Articles Available",
                                    style: theme.textTheme.headlineSmall
                                        ?.copyWith(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: -0.5,
                                        ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    "Check back soon for educational content and expert insights",
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontSize: 16,
                                      color: theme.dividerColor,
                                      height: 1.4,
                                    ),
                                  ),
                                  const SizedBox(height: 40),
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          theme.colorScheme.primary,
                                          theme.colorScheme.primary.withOpacity(
                                            0.8,
                                          ),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(25),
                                      boxShadow: [
                                        BoxShadow(
                                          color: theme.colorScheme.primary
                                              .withOpacity(0.3),
                                          blurRadius: 12,
                                          offset: const Offset(0, 6),
                                        ),
                                      ],
                                    ),
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        context.read<BlogBloc>().add(
                                          FetchBlogs(),
                                        );
                                      },
                                      icon: Icon(
                                        Icons.refresh,
                                        color: theme.colorScheme.onPrimary,
                                      ),
                                      label: Text(
                                        'Refresh',
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                              color:
                                                  theme.colorScheme.onPrimary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 32,
                                          vertical: 16,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            25,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          // Filter blogs based on search query
                          final filteredBlogs = blogs.where((blog) {
                            if (_searchQuery.isEmpty) return true;
                            return blog.title.toLowerCase().contains(
                                  _searchQuery,
                                ) ||
                                blog.shortContent.toLowerCase().contains(
                                  _searchQuery,
                                );
                          }).toList();

                          if (filteredBlogs.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      color: theme.dividerColor.withOpacity(
                                        0.1,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.search_off,
                                      size: 60,
                                      color: theme.dividerColor,
                                    ),
                                  ),
                                  const SizedBox(height: 32),
                                  Text(
                                    "No Articles Found",
                                    style: theme.textTheme.headlineSmall
                                        ?.copyWith(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: -0.5,
                                        ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Try searching for "$_searchQuery" with different keywords',
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontSize: 16,
                                      color: theme.dividerColor,
                                      height: 1.4,
                                    ),
                                  ),
                                  const SizedBox(height: 40),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: theme.dividerColor,
                                      borderRadius: BorderRadius.circular(25),
                                      boxShadow: [
                                        BoxShadow(
                                          color: theme.shadowColor.withOpacity(
                                            0.3,
                                          ),
                                          blurRadius: 12,
                                          offset: const Offset(0, 6),
                                        ),
                                      ],
                                    ),
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        _searchController.clear();
                                        setState(() {
                                          _searchQuery = '';
                                        });
                                      },
                                      icon: Icon(
                                        Icons.clear,
                                        color: theme.colorScheme.onSurface,
                                      ),
                                      label: Text(
                                        'Clear Search',
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                              color:
                                                  theme.colorScheme.onSurface,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 32,
                                          vertical: 16,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            25,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: filteredBlogs.length,
                            itemBuilder: (context, index) {
                              final blog = filteredBlogs[index];
                              return _buildEnhancedBlogCard(blog, index);
                            },
                          );
                        } else if (state is BlogError) {
                          return Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.error.withOpacity(
                                      0.1,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.error_outline,
                                    size: 60,
                                    color: theme.colorScheme.error,
                                  ),
                                ),
                                const SizedBox(height: 32),
                                Text(
                                  "Something Went Wrong",
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: -0.5,
                                      ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  state.message,
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontSize: 16,
                                    color: theme.dividerColor,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 40),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        theme.colorScheme.primary,
                                        theme.colorScheme.primary.withOpacity(
                                          0.8,
                                        ),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(25),
                                    boxShadow: [
                                      BoxShadow(
                                        color: theme.colorScheme.primary
                                            .withOpacity(0.3),
                                        blurRadius: 12,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      context.read<BlogBloc>().add(
                                        FetchBlogs(),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.refresh,
                                      color: theme.colorScheme.onPrimary,
                                    ),
                                    label: Text(
                                      'Try Again',
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: theme.colorScheme.onPrimary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 32,
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEnhancedBlogCard(Blog blog, int index) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => BlogDetailScreen(blog: blog)),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image section with overlay
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: blog.imageUrl.isNotEmpty
                        ? buildBlogImage(blog.imageUrl)
                        : buildPlaceholderImage(),
                  ),
                  // Category badge overlay
                  if (blog.category.isNotEmpty)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: theme.shadowColor.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          blog.category.toUpperCase(),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                    ),
                  // Reading time badge
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: theme.shadowColor.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.access_time,
                            color: theme.colorScheme.onSurface,
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _calculateReadingTime(blog.shortContent),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // Content section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      blog.title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                        letterSpacing: -0.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Content preview
                    Text(
                      blog.shortContent,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        color: theme.dividerColor,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Author and action row
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.person_outline,
                            size: 18,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                blog.author.isNotEmpty
                                    ? blog.author
                                    : 'Anonymous',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Author',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontSize: 11,
                                  color: theme.dividerColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Read more button
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                theme.colorScheme.primary,
                                theme.colorScheme.primary.withOpacity(0.8),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: theme.colorScheme.primary.withOpacity(
                                  0.25,
                                ),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Read",
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onPrimary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 10,
                                  color: theme.colorScheme.onPrimary,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Tags section
                    if (blog.tags.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: blog.tags
                            .take(3)
                            .map(
                              (tag) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary.withOpacity(
                                    0.08,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '#$tag',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.primary
                                        .withOpacity(0.8),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _calculateReadingTime(String content) {
    final wordCount = content.split(' ').length;
    final readingTime = (wordCount / 200)
        .ceil(); // Assuming 200 words per minute
    return '${readingTime}m';
  }

  Widget buildBlogImage(String imageUrl) {
    // Fix: handle empty, relative, and absolute URLs robustly
    if (imageUrl.isEmpty) {
      return buildPlaceholderImage();
    }
    String url = imageUrl;
    if (!imageUrl.startsWith("http")) {
      // Always use server root for relative paths
      // Remove /api from MAIN_URL if present
      String baseUrl = MAIN_URL;
      if (baseUrl.endsWith('/api')) {
        baseUrl = baseUrl.replaceFirst(RegExp(r'/api/?$'), '');
      }
      if (!imageUrl.startsWith('/')) {
        url = '$baseUrl/$imageUrl';
      } else {
        url = '$baseUrl$imageUrl';
      }
    }
    // Debug: print the final image URL
    // ignore: avoid_print
    print('Blog image URL: $url');
    // Try loading as image, fallback to SVG if needed
    return Image.network(
      url,
      height: 180,
      width: double.infinity,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          height: 180,
          color: Colors.grey[200],
          child: const Center(child: CircularProgressIndicator()),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        // If image fails and it's SVG, try SVG loader
        if (url.toLowerCase().endsWith('.svg')) {
          return _buildSvgWithFallback(url);
        }
        // Otherwise show placeholder and error message
        return Column(
          children: [
            buildPlaceholderImage(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Image failed to load',
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSvgWithFallback(String url) {
    // Try to fetch the SVG and check if it's valid before rendering
    return FutureBuilder<String>(
      future: _fetchSvg(url),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Container(
            height: 180,
            color: Colors.grey[200],
            child: const Center(child: CircularProgressIndicator()),
          );
        }
        final svgData = snapshot.data ?? '';
        if (svgData.trim().startsWith('<svg')) {
          return SvgPicture.string(
            svgData,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
          );
        } else {
          // Not valid SVG, show placeholder and error
          return Column(
            children: [
              buildPlaceholderImage(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Invalid SVG or image not found',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Future<String> _fetchSvg(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.body;
      }
    } catch (_) {}
    return '';
  }

  Widget buildPlaceholderImage() {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            kPrimaryColor.withOpacity(0.08),
            kPrimaryColor.withOpacity(0.04),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(Icons.article_outlined, size: 28, color: kPrimaryColor),
          ),
          const SizedBox(height: 12),
          Text(
            'Educational Article',
            style: TextStyle(
              color: kPrimaryColor.withOpacity(0.8),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
