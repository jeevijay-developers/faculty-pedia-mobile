import 'dart:convert';
import 'dart:developer';

import 'package:facultypedia/screens/educators/educator_profile_page.dart';
import 'package:facultypedia/router/router.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

// pages
import 'package:facultypedia/screens/courses/course_details_page.dart';

class NeetHomePage extends StatefulWidget {
  const NeetHomePage({super.key});

  @override
  State<NeetHomePage> createState() => _NeetHomePageState();
}

class _NeetHomePageState extends State<NeetHomePage>
    with TickerProviderStateMixin {
  List<dynamic> categories = [];
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
    final data = await json.decode(response);

    final filtered = (data["categories"] as List).where((cat) {
      final title = cat["title"].toString().toLowerCase();
      return title.contains("neet");
    }).toList();

    setState(() {
      categories = filtered;
    });
  }

  List<dynamic> get _filteredCategories {
    if (_searchQuery.isEmpty) return categories;

    return categories.where((category) {
      final title = category["title"]?.toString().toLowerCase() ?? '';
      final description =
          category["description"]?.toString().toLowerCase() ?? '';
      final query = _searchQuery.toLowerCase();

      return title.contains(query) || description.contains(query);
    }).toList();
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
                    hintText: 'Search NEET courses...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: theme.hintColor),
                  ),
                  style: theme.textTheme.bodyLarge,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
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
      body: categories.isEmpty
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              ),
            )
          : SingleChildScrollView(
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
                          primaryColor.withOpacity(0.05),
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                      child: Column(
                        children: [
                          Text(
                            "🩺 NEET - UG",
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Master NEET with expert guidance in Biology, Chemistry & Physics",
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

                  // Featured Educators Section
                  _buildModernSection(
                    theme,
                    "Featured Educators",
                    "Top-rated instructors for NEET preparation",
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
                            "Dr. Ankur Gupta",
                            "Chemistry",
                            "PhD, Chemistry",
                            "12 years",
                            "Physical Chemistry",
                            "https://placehold.co/600x400.png",
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EducatorProfilePage(
                                    id: "demo_educator_3",
                                    name: "Dr. Ankur Gupta",
                                    subject: "Chemistry",
                                    description: "Expert in Physical Chemistry",
                                    education: "PhD, Chemistry",
                                    experience: "12 years",
                                    rating: 4.8,
                                    reviews: 120,
                                    followers: 500,
                                    tag: "IIT-JEE",
                                    imageUrl:
                                        "https://placehold.co/600x400.png",
                                    youtubeUrl: "https://www.youtube.com/",
                                    email: "ankur.gupta@example.com",
                                    phone: "123-456-7890",
                                    socialLinks: const {
                                      "LinkedIn":
                                          "https://www.linkedin.com/in/ankur-gupta",
                                      "Twitter":
                                          "https://twitter.com/ankur_gupta",
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
                            "Dr. Rajiv Mehta",
                            "Physics",
                            "PhD, Physics",
                            "10 years",
                            "Mechanics & Electrodynamics",
                            "https://placehold.co/600x400.png",
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EducatorProfilePage(
                                    id: "demo_educator_4",
                                    name: "Dr. Rajiv Mehta",
                                    subject: "Physics",
                                    description:
                                        "Expert in Mechanics & Electrodynamics",
                                    education: "PhD, Physics",
                                    experience: "10 years",
                                    rating: 4.7,
                                    reviews: 100,
                                    followers: 450,
                                    tag: "IIT-JEE",
                                    imageUrl:
                                        "https://placehold.co/600x400.png",
                                    youtubeUrl: "https://www.youtube.com/",
                                    email: "rajiv.mehta@example.com",
                                    phone: "987-654-3210",
                                    socialLinks: const {
                                      "LinkedIn":
                                          "https://www.linkedin.com/in/rajiv-mehta",
                                      "Twitter":
                                          "https://twitter.com/rajiv_mehta",
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
                        arguments: {'category': 'NEET'},
                      );
                    },
                  ),

                  // Course Categories
                  ..._filteredCategories.map((category) {
                    return _buildModernCategorySection(
                      context,
                      category,
                      theme,
                    );
                  }).toList(),

                  // Live Courses Section
                  _buildModernSection(
                    theme,
                    "1 V 1 Live Course Classes",
                    "Personalized one-on-one learning sessions",
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 380,
                        enlargeCenterPage: false,
                        enableInfiniteScroll: false,
                        viewportFraction: 0.85,
                        autoPlay: false,
                        padEnds: false,
                      ),
                      items: [
                        Container(
                          margin: const EdgeInsets.only(right: 16, left: 4),
                          child: _buildModernLiveCard(
                            theme,
                            'Physics Concepts Simplified',
                            "Dr Rajiv Mehta",
                            "Ph.D., Physics",
                            "Physics",
                            38,
                            "14,500",
                            'https://placehold.co/600x400.png',
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CourseDetailsPage(
                                    title: 'Physics Concepts Simplified',
                                    educatorName: "Dr Rajiv Mehta",
                                    description:
                                        "A deep dive into the fundamental concepts of Physics.",
                                    durationText: "38 hours",
                                    price: 14500,
                                    oldPrice: 16000,
                                    imageUrl:
                                        'https://placehold.co/600x400.png',
                                    tag: 'Physics',
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 16, left: 4),
                          child: _buildModernLiveCard(
                            theme,
                            'Advanced Chemistry',
                            "Dr Ankur Gupta",
                            "Ph.D., Chemistry",
                            "Chemistry",
                            40,
                            "15,000",
                            'https://placehold.co/600x400.png',
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CourseDetailsPage(
                                    title: 'Advanced Chemistry',
                                    educatorName: "Dr Ankur Gupta",
                                    description:
                                        "An in-depth exploration of chemical principles.",
                                    durationText: "40 hours",
                                    price: 15000,
                                    oldPrice: 16000,
                                    imageUrl:
                                        'https://placehold.co/600x400.png',
                                    tag: 'Chemistry',
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
                        AppRouter.testSeries,
                        arguments: {'category': 'NEET'},
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

  Widget _buildModernCategorySection(
    BuildContext context,
    Map<String, dynamic> category,
    ThemeData theme,
  ) {
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
                        category["title"],
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${(category["courses"] as List).length} courses available",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.hintColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextButton.icon(
                    onPressed: () {
                      log("View All pressed");
                      Navigator.pushNamed(
                        context,
                        AppRouter.coursesCategory,
                        arguments: {
                          'category': 'NEET',
                          'categoryTitle': category["title"] ?? 'NEET Courses',
                        },
                      );
                    },
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
          CarouselSlider(
            options: CarouselOptions(
              height: 420,
              enlargeCenterPage: false,
              enableInfiniteScroll: false,
              viewportFraction: 0.85,
              autoPlay: false,
              padEnds: false,
            ),
            items: (category["courses"] as List).map((course) {
              return Container(
                margin: const EdgeInsets.only(right: 16, left: 4),
                child: _buildModernCourseCard(context, course, theme),
              );
            }).toList(),
          ),
        ],
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

  Widget _buildModernLiveCard(
    ThemeData theme,
    String title,
    String instructorName,
    String qualification,
    String subject,
    int totalHours,
    String fee,
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
              height: 160,
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
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "LIVE",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
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
                        "$totalHours hours",
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
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
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
                          radius: 10,
                          backgroundColor: theme.colorScheme.primary
                              .withOpacity(0.1),
                          child: Icon(
                            Icons.person,
                            size: 12,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            instructorName,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.hintColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      qualification,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.hintColor,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        subject,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "₹$fee",
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: onTap,
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
