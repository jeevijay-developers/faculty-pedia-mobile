import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:facultypedia/screens/courses/course_details_page.dart';

const Color kPrimaryColor = Color(0xFF4A90E2);

class CoursesCategoryScreen extends StatefulWidget {
  final String category;
  final String? categoryTitle;

  const CoursesCategoryScreen({
    super.key,
    required this.category,
    this.categoryTitle,
  });

  @override
  State<CoursesCategoryScreen> createState() => _CoursesCategoryScreenState();
}

class _CoursesCategoryScreenState extends State<CoursesCategoryScreen> {
  List<dynamic> courses = [];
  List<dynamic> filteredCourses = [];
  bool isLoading = true;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchExpanded = false;

  @override
  void initState() {
    super.initState();
    loadCourses();
  }

  Future<void> loadCourses() async {
    try {
      print(
        'CoursesCategoryScreen: Loading courses for category: "${widget.category}"',
      );

      final String response = await rootBundle.loadString(
        'assets/data/courses.json',
      );
      final data = await json.decode(response);

      // Find courses for the specific category
      List<dynamic> allCourses = [];

      for (var category in data["categories"]) {
        if (category["courses"] != null) {
          String categoryTitle =
              category["title"]?.toString().toLowerCase() ?? '';
          String targetCategory = widget.category.toLowerCase();
          
          print('CoursesCategoryScreen: Checking category "${category["title"]}" (lowercase: "$categoryTitle") against target "$targetCategory"');

          // Check if this category matches our target category
          bool categoryMatches = false;

          if (targetCategory.contains("jee mains") ||
              targetCategory.contains("jee main")) {
            categoryMatches =
                categoryTitle.contains("jee") && categoryTitle.contains("main");
            print('CoursesCategoryScreen: JEE Main check - categoryMatches = $categoryMatches');
          } else if (targetCategory.contains("jee advanced") ||
              targetCategory.contains("jee advance")) {
            categoryMatches =
                categoryTitle.contains("jee") &&
                categoryTitle.contains("advance");
            print('CoursesCategoryScreen: JEE Advanced check - categoryMatches = $categoryMatches');
          } else if (targetCategory.contains("neet")) {
            categoryMatches = categoryTitle.contains("neet");
            print('CoursesCategoryScreen: NEET check - categoryMatches = $categoryMatches');
          } else if (targetCategory.contains("cbse")) {
            categoryMatches = categoryTitle.contains("cbse");
            print('CoursesCategoryScreen: CBSE check - categoryMatches = $categoryMatches');
          } else {
            categoryMatches = categoryTitle.contains(targetCategory);
            print('CoursesCategoryScreen: Default check - categoryMatches = $categoryMatches');
          }

          // If category matches, add all its courses
          if (categoryMatches) {
            print(
              'CoursesCategoryScreen: Matched category "${category["title"]}" for target "$targetCategory"',
            );
            allCourses.addAll(category["courses"]);
          }
        }
      }

      setState(() {
        courses = allCourses;
        filteredCourses = allCourses;
        isLoading = false;
      });

      print(
        'CoursesCategoryScreen: Loaded ${allCourses.length} courses for category: ${widget.category}',
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error loading courses: $e');
    }
  }

  void _filterCourses() {
    setState(() {
      if (_searchQuery.isEmpty) {
        filteredCourses = courses;
      } else {
        filteredCourses = courses.where((course) {
          final title = course['title']?.toString().toLowerCase() ?? '';
          final instructor =
              course['instructor']?.toString().toLowerCase() ?? '';
          final query = _searchQuery.toLowerCase();
          return title.contains(query) || instructor.contains(query);
        }).toList();
      }
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearchExpanded = !_isSearchExpanded;
      if (!_isSearchExpanded) {
        _searchController.clear();
        _searchQuery = '';
        _filterCourses();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String displayTitle = widget.categoryTitle ?? '${widget.category} Courses';

    return Scaffold(
      backgroundColor: Colors.grey[50],
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
            child: Icon(Icons.arrow_back, color: kPrimaryColor, size: 16),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: _isSearchExpanded
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search courses...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey[500]),
                ),
                style: const TextStyle(color: Colors.black87, fontSize: 16),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                  _filterCourses();
                },
              )
            : Text(
                displayTitle,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _isSearchExpanded ? Icons.close : Icons.search,
                color: kPrimaryColor,
                size: 16,
              ),
            ),
            onPressed: _toggleSearch,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Header Section
                Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(24),
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
                    children: [
                      Text(
                        displayTitle,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                          letterSpacing: -0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${filteredCourses.length} courses available",
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                // Courses List
                Expanded(
                  child: filteredCourses.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _searchQuery.isNotEmpty
                                    ? 'No courses found for "$_searchQuery"'
                                    : 'No courses available in this category',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: filteredCourses.length,
                          itemBuilder: (context, index) {
                            final course = filteredCourses[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              child: _buildCourseCard(context, course),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildCourseCard(BuildContext context, Map<String, dynamic> course) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CourseDetailsPage(
              title: course['title'] ?? 'Course',
              educatorName: course['instructor'] ?? 'Instructor',
              description: course['description'] ?? 'Course description',
              durationText: "${course['duration'] ?? 0} hours",
              price: course['price'] ?? 0,
              oldPrice: course['originalPrice'] ?? course['price'] ?? 0,
              imageUrl: course['image'] ?? 'https://placehold.co/600x400.png',
              tag: course['category'] ?? widget.category,
            ),
          ),
        );
      },
      child: Container(
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
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Image.network(
                course['image'] ?? 'https://placehold.co/600x400.png',
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 160,
                    color: Colors.grey[200],
                    child: Icon(
                      Icons.image_not_supported,
                      color: Colors.grey[400],
                      size: 40,
                    ),
                  );
                },
              ),
            ),

            // Course Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Category Badge
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          course['title'] ?? 'Course Title',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                            height: 1.3,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: kPrimaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          course['category'] ?? widget.category,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Instructor
                  Text(
                    "By ${course['instructor'] ?? 'Instructor'}",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Course Details Row
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "${course['duration'] ?? 0}h",
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.play_lesson,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "${course['lessons'] ?? 0} lessons",
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Price and Enroll Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (course['originalPrice'] != null &&
                              course['originalPrice'] > course['price'])
                            Text(
                              "₹${course['originalPrice']}",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          Text(
                            "₹${course['price'] ?? 0}",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
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
                                title: course['title'] ?? 'Course',
                                educatorName:
                                    course['instructor'] ?? 'Instructor',
                                description:
                                    course['description'] ??
                                    'Course description',
                                durationText:
                                    "${course['duration'] ?? 0} hours",
                                price: course['price'] ?? 0,
                                oldPrice:
                                    course['originalPrice'] ??
                                    course['price'] ??
                                    0,
                                imageUrl:
                                    course['image'] ??
                                    'https://placehold.co/600x400.png',
                                tag: course['category'] ?? widget.category,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        child: const Text(
                          "Enroll",
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
          ],
        ),
      ),
    );
  }
}
