import 'dart:convert';

import 'package:facultypedia/screens/educators/educator_profile_page.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

// components

import 'package:facultypedia/components/custom_drawer.dart';

// pages
import 'package:facultypedia/screens/courses/course_details_page.dart';

const Color kPrimaryColor = Color(0xFF4A90E2);

class NeetHomePage extends StatefulWidget {
  const NeetHomePage({super.key});

  @override
  State<NeetHomePage> createState() => _NeetHomePageState();
}

class _NeetHomePageState extends State<NeetHomePage> {
  List<dynamic> categories = [];

  @override
  void initState() {
    super.initState();
    loadCourses();
  }

  Future<void> loadCourses() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/data/courses.json',
      );
      final data = await json.decode(response);

      // ✅ Filter only "NEET" related courses - more flexible filtering
      final filtered = (data["categories"] as List? ?? []).where((cat) {
        final title = (cat["title"] ?? "").toString().toLowerCase();
        return title.contains("neet") ||
            title.contains("biology") ||
            title.contains("chemistry") ||
            title.contains("physics");
      }).toList();

      setState(() {
        categories = filtered;
      });

      // If no NEET courses found, add fallback courses
      if (filtered.isEmpty) {
        setState(() {
          categories = [
            {
              "title": "NEET Biology",
              "courses": [
                {
                  "title": "NEET Biology Complete Course",
                  "educatorName": "Prof. Neha Sharma",
                  "description":
                      "Complete Biology preparation for NEET with detailed explanations",
                  "durationText": "12 months",
                  "price": 15999,
                  "oldPrice": 20999,
                  "imageUrl": "https://placehold.co/600x400.png",
                  "tag": "NEET",
                  "stats": {"enrolled": 150},
                },
              ],
            },
            {
              "title": "NEET Chemistry",
              "courses": [
                {
                  "title": "NEET Chemistry Master Class",
                  "educatorName": "Dr. Ankur Gupta",
                  "description":
                      "Complete Chemistry preparation covering all NEET topics",
                  "durationText": "10 months",
                  "price": 14999,
                  "oldPrice": 19999,
                  "imageUrl": "https://placehold.co/600x400.png",
                  "tag": "NEET",
                  "stats": {"enrolled": 120},
                },
              ],
            },
            {
              "title": "NEET Physics",
              "courses": [
                {
                  "title": "NEET Physics Complete Package",
                  "educatorName": "Dr. Rajiv Mehta",
                  "description":
                      "Complete Physics preparation for NEET entrance exam",
                  "durationText": "10 months",
                  "price": 13999,
                  "oldPrice": 18999,
                  "imageUrl": "https://placehold.co/600x400.png",
                  "tag": "NEET",
                  "stats": {"enrolled": 100},
                },
              ],
            },
          ];
        });
      }
    } catch (e) {
      print('Error loading courses: $e');
      // Set fallback categories on error
      setState(() {
        categories = [
          {
            "title": "NEET Preparation",
            "courses": [
              {
                "title": "Complete NEET Preparation",
                "educatorName": "Expert Faculty",
                "description": "Comprehensive NEET preparation course",
                "durationText": "12 months",
                "price": 19999,
                "oldPrice": 25999,
                "imageUrl": "https://placehold.co/600x400.png",
                "tag": "NEET",
                "stats": {"enrolled": 200},
              },
            ],
          },
        ];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: kPrimaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.menu, color: kPrimaryColor, size: 16),
          ),
          onPressed: () => scaffoldKey.currentState?.openDrawer(),
        ),
        title: Container(
          height: 40,
          child: Image.asset("assets/images/fp.png"),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.search, color: kPrimaryColor, size: 20),
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: const CustomDrawer(),
      body: categories.isEmpty
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
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
                        colors: [Colors.white, kPrimaryColor.withOpacity(0.05)],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                      child: Column(
                        children: [
                          Text(
                            "🩺 NEET - UG",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Master NEET with expert guidance in Biology, Chemistry & Physics",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Featured Educators Section
                  _buildModernSection(
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
                                    name: "Dr. Ankur Gupta",
                                    subject: "Chemistry",
                                    description: "Expert in Physical Chemistry",
                                    education: "PhD, Chemistry",
                                    experience: "12 years",
                                    rating: 4.8,
                                    reviews: 120,
                                    followers: 500,
                                    tag: "NEET",
                                    imageUrl:
                                        "https://placehold.co/600x400.png",
                                    youtubeUrl: "https://www.youtube.com/",
                                    email: "ankur.gupta@example.com",
                                    phone: "123-456-7890",
                                    socialLinks: {
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
                            "Prof. Neha Sharma",
                            "Biology",
                            "PhD, Biology",
                            "15 years",
                            "Biotechnology & Genetics",
                            "https://placehold.co/600x400.png",
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EducatorProfilePage(
                                    name: "Prof. Neha Sharma",
                                    subject: "Biology",
                                    description:
                                        "Expert in Biotechnology & Genetics",
                                    education: "PhD, Biology",
                                    experience: "15 years",
                                    rating: 4.9,
                                    reviews: 95,
                                    followers: 750,
                                    tag: "NEET",
                                    imageUrl:
                                        "https://placehold.co/600x400.png",
                                    youtubeUrl: "https://www.youtube.com/",
                                    email: "neha.sharma@example.com",
                                    phone: "123-456-7891",
                                    socialLinks: {
                                      "LinkedIn":
                                          "https://www.linkedin.com/in/neha-sharma",
                                      "Twitter":
                                          "https://twitter.com/neha_sharma",
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
                                    name: "Dr. Rajiv Mehta",
                                    subject: "Physics",
                                    description:
                                        "Expert in Mechanics & Electrodynamics",
                                    education: "PhD, Physics",
                                    experience: "10 years",
                                    rating: 4.7,
                                    reviews: 80,
                                    followers: 600,
                                    tag: "NEET",
                                    imageUrl:
                                        "https://placehold.co/600x400.png",
                                    youtubeUrl: "https://www.youtube.com/",
                                    email: "rajiv.mehta@example.com",
                                    phone: "123-456-7892",
                                    socialLinks: {
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
                  ),

                  // Course Categories
                  ...categories.map((category) {
                    return _buildCategorySection(category);
                  }).toList(),

                  // Live Courses Section
                  _buildModernSection(
                    "🔴 Live Courses",
                    "Join interactive classes for real-time learning",
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
                            'Physics Concepts Simplified',
                            "Dr. Rajiv Mehta",
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
                                    educatorName: "Dr. Rajiv Mehta",
                                    description:
                                        "Interactive live physics sessions for NEET preparation",
                                    durationText: "38 hours",
                                    price: 14500,
                                    oldPrice: 18000,
                                    imageUrl:
                                        'https://placehold.co/600x400.png',
                                    tag: 'Live',
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 16, left: 4),
                          child: _buildModernLiveCard(
                            'Biology Master Class',
                            "Prof. Neha Sharma",
                            "Ph.D., Biology",
                            "Biology",
                            42,
                            "16,500",
                            'https://placehold.co/600x400.png',
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CourseDetailsPage(
                                    title: 'Biology Master Class',
                                    educatorName: "Prof. Neha Sharma",
                                    description:
                                        "Comprehensive biology course for medical entrance exams",
                                    durationText: "42 hours",
                                    price: 16500,
                                    oldPrice: 20000,
                                    imageUrl:
                                        'https://placehold.co/600x400.png',
                                    tag: 'Live',
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 16, left: 4),
                          child: _buildModernLiveCard(
                            'Chemistry Complete Package',
                            "Dr. Ankur Gupta",
                            "Ph.D., Chemistry",
                            "Chemistry",
                            45,
                            "18,000",
                            'https://placehold.co/600x400.png',
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CourseDetailsPage(
                                    title: 'Chemistry Complete Package',
                                    educatorName: "Dr. Ankur Gupta",
                                    description:
                                        "Complete chemistry preparation with practical experiments",
                                    durationText: "45 hours",
                                    price: 18000,
                                    oldPrice: 22000,
                                    imageUrl:
                                        'https://placehold.co/600x400.png',
                                    tag: 'Live',
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget _buildModernSection(String title, String subtitle, Widget content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
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
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: kPrimaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextButton.icon(
                    onPressed: () {},
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: kPrimaryColor,
                    ),
                    label: Text(
                      "View All",
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          content,
        ],
      ),
    );
  }

  Widget _buildModernEducatorCard(
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
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image & Subject Tag
            Container(
              height: 140,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                color: kPrimaryColor.withOpacity(0.1),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        color: Colors.grey[300],
                      ),
                      child: ClipOval(
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: Icon(
                                Icons.person,
                                size: 40,
                                color: Colors.grey[600],
                              ),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        subject,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      specialization,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(
                          Icons.school_outlined,
                          size: 14,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            education,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.work_outline_outlined,
                          size: 14,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          experience,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
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

  Widget _buildCategorySection(dynamic category) {
    final courses = (category["courses"] as List? ?? []);
    final categoryTitle = category["title"] ?? "Courses";

    if (courses.isEmpty) {
      return Container(); // Return empty container if no courses
    }

    return _buildModernSection(
      categoryTitle,
      "Choose from ${courses.length} expert-led courses",
      CarouselSlider(
        options: CarouselOptions(
          height: 280,
          enlargeCenterPage: false,
          enableInfiniteScroll: courses.length > 2,
          viewportFraction: 0.85,
          autoPlay: courses.length > 2,
          autoPlayInterval: const Duration(seconds: 6),
          padEnds: false,
        ),
        items: courses.map((course) {
          return Container(
            margin: const EdgeInsets.only(right: 16, left: 4),
            child: _buildModernCourseCard(context, course),
          );
        }).toList(),
      ),
    );
  }

  // Modern Course Card (same as IIT screen)
  Widget _buildModernCourseCard(
    BuildContext context,
    Map<String, dynamic> course,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CourseDetailsPage(
              title: course["title"] ?? "Course Title",
              educatorName:
                  course["educatorName"] ?? course["educator"] ?? "Educator",
              description:
                  course["description"] ?? course["longDescription"] ?? "",
              durationText:
                  course["durationText"] ?? course["duration"] ?? "Duration",
              price: course["price"] ?? 0,
              oldPrice: course["oldPrice"] ?? course["price"] ?? 0,
              imageUrl:
                  course["imageUrl"] ??
                  course["image"] ??
                  "https://placehold.co/600x400.png",
              tag: course["tag"] ?? "Course",
            ),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course Image
            Container(
              height: 180,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: Colors.grey[200],
              ),
              child: Stack(
                children: [
                  // Background Image
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      child: Image.network(
                        course["imageUrl"] ??
                            course["image"] ??
                            "https://placehold.co/600x400.png",
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: Center(
                              child: Icon(
                                Icons.image_not_supported,
                                size: 40,
                                color: Colors.grey[600],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
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
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.bookmark_border,
                        color: kPrimaryColor,
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
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        course["durationText"] ??
                            course["duration"] ??
                            "Duration",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Course Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course["title"] ?? "Course Title",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
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
                          backgroundColor: kPrimaryColor.withOpacity(0.1),
                          child: Icon(
                            Icons.person,
                            size: 14,
                            color: kPrimaryColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            course["educatorName"] ??
                                course["educator"] ??
                                "Educator",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      course["description"] ?? course["longDescription"] ?? "",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        height: 1.4,
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
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            Text(
                              "₹${course["price"] ?? 0}",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: kPrimaryColor,
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
                                  title: course["title"] ?? "Course Title",
                                  educatorName:
                                      course["educatorName"] ??
                                      course["educator"] ??
                                      "Educator",
                                  description:
                                      course["description"] ??
                                      course["longDescription"] ??
                                      "",
                                  durationText:
                                      course["durationText"] ??
                                      course["duration"] ??
                                      "Duration",
                                  price: course["price"] ?? 0,
                                  oldPrice:
                                      course["oldPrice"] ??
                                      course["price"] ??
                                      0,
                                  imageUrl:
                                      course["imageUrl"] ??
                                      course["image"] ??
                                      "https://placehold.co/600x400.png",
                                  tag: course["tag"] ?? "Course",
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Enroll Now",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course Image
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
                      child: const Text(
                        "LIVE",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
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
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "$totalHours hours",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Course Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
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
                          backgroundColor: kPrimaryColor.withOpacity(0.1),
                          child: Icon(
                            Icons.person,
                            size: 12,
                            color: kPrimaryColor,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            instructorName,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      qualification,
                      style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: kPrimaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        subject,
                        style: TextStyle(
                          fontSize: 10,
                          color: kPrimaryColor,
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
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: kPrimaryColor,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: onTap,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Enroll",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
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
