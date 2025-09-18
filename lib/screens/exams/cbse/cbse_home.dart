import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

// pages
import 'package:facultypedia/screens/courses/course_details_page.dart';
import 'package:facultypedia/screens/educators/educator_profile_page.dart';
import 'package:facultypedia/router/router.dart';

class CBSEHome extends StatefulWidget {
  const CBSEHome({super.key});

  @override
  State<CBSEHome> createState() => _CBSEHomeState();
}

class _CBSEHomeState extends State<CBSEHome> with TickerProviderStateMixin {
  List<dynamic> allCourses = [];
  List<dynamic> filteredCourses = [];
  String? selectedClass;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

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
    loadCourses();
  }

  Future<void> loadCourses() async {
    final String response = await rootBundle.loadString(
      'assets/data/courses.json',
    );
    final data = json.decode(response);

    final cbseCategory = (data['categories'] as List).firstWhere(
      (cat) => cat['title'] == "Courses for CBSE",
      orElse: () => null,
    );

    if (cbseCategory != null) {
      setState(() {
        allCourses = cbseCategory['courses'];
        filteredCourses = allCourses;
      });
    }
  }

  void filterByClass(String? className) {
    setState(() {
      selectedClass = className;
      _applyFilters();
    });
  }

  void _applyFilters() {
    List<dynamic> filtered = allCourses;

    if (selectedClass != null && selectedClass != "All") {
      filtered = filtered.where((course) {
        return course['title'].toString().contains(selectedClass!);
      }).toList();
    }

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((course) {
        final title = course['title']?.toString().toLowerCase() ?? '';
        final description =
            course['description']?.toString().toLowerCase() ?? '';
        final query = _searchQuery.toLowerCase();
        return title.contains(query) || description.contains(query);
      }).toList();
    }

    setState(() {
      filteredCourses = filtered;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.arrow_back, color: primaryColor, size: 16),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: _isSearchExpanded
            ? FadeTransition(
                opacity: _fadeAnimation,
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Search CBSE courses...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: theme.hintColor),
                  ),
                  style: theme.textTheme.bodyLarge,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                      _applyFilters();
                    });
                  },
                ),
              )
            : SizedBox(height: 40, child: Image.asset("assets/images/fp.png")),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _isSearchExpanded ? Icons.close : Icons.search,
                color: primaryColor,
                size: 20,
              ),
            ),
            onPressed: () {
              setState(() {
                if (_isSearchExpanded) {
                  _isSearchExpanded = false;
                  _searchController.clear();
                  _searchQuery = '';
                  _animationController.reverse();
                  _applyFilters();
                } else {
                  _isSearchExpanded = true;
                  _animationController.forward();
                }
              });
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [theme.cardColor, primaryColor.withOpacity(0.05)],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                child: Column(
                  children: [
                    Text(
                      "📚 CBSE / NEET",
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Excellence in CBSE curriculum and NEET preparation",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.hintColor,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Class Filter Section
            Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withOpacity(0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Select Your Class",
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: "Choose class to filter courses",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      value: selectedClass,
                      items:
                          [
                                "All",
                                "Class 6",
                                "Class 7",
                                "Class 8",
                                "Class 9",
                                "Class 10",
                                "Class 11",
                                "Class 12",
                              ]
                              .map(
                                (label) => DropdownMenuItem(
                                  value: label,
                                  child: Text(label),
                                ),
                              )
                              .toList(),
                      onChanged: filterByClass,
                    ),
                  ],
                ),
              ),
            ),

            // Featured Educators Section
            _buildModernSection(
              theme,
              "Featured Educators",
              "Expert teachers for CBSE and NEET preparation",
              CarouselSlider(
                options: CarouselOptions(
                  height: 320,
                  enlargeCenterPage: false,
                  enableInfiniteScroll: false,
                  viewportFraction: 0.85,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 4),
                  padEnds: false,
                ),
                items: [
                  Container(
                    margin: const EdgeInsets.only(right: 16, left: 4),
                    child: _buildModernEducatorCard(
                      theme,
                      "Dr. Priya Sharma",
                      "Biology",
                      "PhD, Biology",
                      "15 years",
                      "NEET Biology Expert",
                      "https://placehold.co/600x400.png",
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EducatorProfilePage(
                              id: "demo_educator_5",
                              name: "Dr. Priya Sharma",
                              subject: "Biology",
                              description: "Expert in NEET Biology preparation",
                              education: "PhD, Biology",
                              experience: "15 years",
                              rating: 4.9,
                              reviews: 150,
                              followers: 600,
                              tag: "NEET",
                              imageUrl: "https://placehold.co/600x400.png",
                              youtubeUrl: "https://www.youtube.com/",
                              email: "priya.sharma@example.com",
                              phone: "123-456-7890",
                              socialLinks: const {
                                "LinkedIn":
                                    "https://www.linkedin.com/in/priya-sharma",
                                "Twitter": "https://twitter.com/priya_sharma",
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 16, left: 4),
                    child: _buildModernEducatorCard(
                      theme,
                      "Prof. Amit Kumar",
                      "Mathematics",
                      "M.Sc, Mathematics",
                      "12 years",
                      "CBSE Mathematics Expert",
                      "https://placehold.co/600x400.png",
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EducatorProfilePage(
                              id: "demo_educator_6",
                              name: "Prof. Amit Kumar",
                              subject: "Mathematics",
                              description: "Expert in CBSE Mathematics",
                              education: "M.Sc, Mathematics",
                              experience: "12 years",
                              rating: 4.8,
                              reviews: 120,
                              followers: 450,
                              tag: "CBSE",
                              imageUrl: "https://placehold.co/600x400.png",
                              youtubeUrl: "https://www.youtube.com/",
                              email: "amit.kumar@example.com",
                              phone: "987-654-3210",
                              socialLinks: const {
                                "LinkedIn":
                                    "https://www.linkedin.com/in/amit-kumar",
                                "Twitter": "https://twitter.com/amit_kumar",
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              onViewAllPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRouter.educators,
                  arguments: {'category': 'CBSE'},
                );
              },
            ),

            // Courses Section
            _buildModernSection(
              theme,
              selectedClass != null && selectedClass != "All"
                  ? "$selectedClass Courses"
                  : "CBSE Courses",
              "${filteredCourses.length} courses available",
              filteredCourses.isEmpty
                  ? SizedBox(
                      height: 200,
                      child: Center(
                        child: Text(
                          "No courses found for the selected class",
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.hintColor,
                          ),
                        ),
                      ),
                    )
                  : CarouselSlider(
                      options: CarouselOptions(
                        height: 420,
                        enlargeCenterPage: false,
                        enableInfiniteScroll: false,
                        viewportFraction: 0.85,
                        autoPlay: false,
                        padEnds: false,
                      ),
                      items: filteredCourses.map((course) {
                        return Container(
                          margin: const EdgeInsets.only(right: 16, left: 4),
                          child: _buildModernCourseCard(context, course, theme),
                        );
                      }).toList(),
                    ),
              onViewAllPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRouter.courses,
                  arguments: {'category': 'CBSE'},
                );
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildModernSection(
    ThemeData theme,
    String title,
    String subtitle,
    Widget content, {
    VoidCallback? onViewAllPressed,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.hintColor,
                        ),
                      ),
                    ],
                  ),
                ),
                if (onViewAllPressed != null)
                  Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextButton.icon(
                      onPressed: onViewAllPressed,
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: theme.colorScheme.primary,
                      ),
                      label: Text(
                        "View All",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          content,
        ],
      ),
    );
  }

  Widget _buildModernEducatorCard(
    ThemeData theme,
    String name,
    String subject,
    String education,
    String experience,
    String specialization,
    String imageUrl,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 140,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.3),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        subject,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      education,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.hintColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      specialization,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.4,
                        color: theme.hintColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "$experience experience",
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: onTap,
                          child: const Text("View Profile"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernCourseCard(
    BuildContext context,
    Map<String, dynamic> course,
    ThemeData theme,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CourseDetailsPage(
              title: course["title"],
              educatorName: course["educatorName"],
              description: course["description"],
              durationText: course["durationText"],
              price: course["price"],
              oldPrice: course["oldPrice"],
              imageUrl: course["imageUrl"],
              tag: course["tag"] ?? '',
            ),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 180,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                image: DecorationImage(
                  image: NetworkImage(course["imageUrl"]),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.3),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: theme.cardColor.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.bookmark_border,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        course["durationText"],
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course["title"],
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: theme.colorScheme.primary
                              .withOpacity(0.1),
                          child: Icon(
                            Icons.person,
                            size: 14,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            course["educatorName"],
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.hintColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      course["description"],
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.4,
                        color: theme.hintColor,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (course["oldPrice"] != null)
                              Text(
                                "₹${course["oldPrice"]}",
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.hintColor,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            Text(
                              "₹${course["price"]}",
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CourseDetailsPage(
                                  title: course["title"],
                                  educatorName: course["educatorName"],
                                  description: course["description"],
                                  durationText: course["durationText"],
                                  price: course["price"],
                                  oldPrice: course["oldPrice"],
                                  imageUrl: course["imageUrl"],
                                  tag: course["tag"] ?? '',
                                ),
                              ),
                            );
                          },
                          child: const Text("Enroll"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
