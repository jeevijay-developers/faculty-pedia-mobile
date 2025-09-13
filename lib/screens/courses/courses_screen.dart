import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:facultypedia/components/custom_drawer.dart';
import 'package:facultypedia/screens/courses/course_details_page.dart';
import 'package:facultypedia/router/router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const Color kPrimaryColor = Color(0xFF4A90E2);

class CoursesPage extends StatefulWidget {
  final String? preselectedCategory;

  const CoursesPage({super.key, this.preselectedCategory});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage>
    with TickerProviderStateMixin {
  List<dynamic> categories = [];
  String selectedCategory = "All";
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<String> categoryFilters = [
    "All",
    "JEE Advanced",
    "JEE Mains",
    "NEET",
    "CBSE",
    "Foundation",
  ];

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

    // Set preselected category if provided
    if (widget.preselectedCategory != null &&
        categoryFilters.contains(widget.preselectedCategory)) {
      selectedCategory = widget.preselectedCategory!;
    }

    loadCourses();
  }

  Future<void> loadCourses() async {
    final String response = await rootBundle.loadString(
      'assets/data/courses.json',
    );
    final data = await json.decode(response);
    setState(() {
      categories = data["categories"];
    });
  }

  List<dynamic> get _filteredCategories {
    var filtered = categories;

    // Filter by selected category
    if (selectedCategory != "All") {
      filtered = filtered.where((category) {
        final title = category["title"]?.toString().toLowerCase() ?? '';
        final selectedLower = selectedCategory.toLowerCase();
        return title.contains(selectedLower);
      }).toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((category) {
        final title = category["title"]?.toString().toLowerCase() ?? '';
        final description =
            category["description"]?.toString().toLowerCase() ?? '';
        final query = _searchQuery.toLowerCase();

        return title.contains(query) || description.contains(query);
      }).toList();
    }

    return filtered;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: theme.cardColor,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: widget.preselectedCategory != null
                ? Icon(
                    Icons.arrow_back,
                    color: theme.colorScheme.primary,
                    size: 16,
                  )
                : FaIcon(
                    FontAwesomeIcons.bars,
                    color: theme.colorScheme.primary,
                    size: 16,
                  ),
          ),
          onPressed: widget.preselectedCategory != null
              ? () => Navigator.pop(context)
              : () => scaffoldKey.currentState?.openDrawer(),
        ),
        title: _isSearchExpanded
            ? FadeTransition(
                opacity: _fadeAnimation,
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Search courses...',
                    border: InputBorder.none,
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodyMedium?.color?.withOpacity(
                        0.5,
                      ),
                    ),
                  ),
                  style: theme.textTheme.bodyLarge?.copyWith(fontSize: 16),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              )
            : Container(height: 40, child: Image.asset("assets/images/fp.png")),
        centerTitle: true,
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
                color: primary,
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
      drawer: widget.preselectedCategory != null ? null : const CustomDrawer(),
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
                            "Explore Courses",
                            style: theme.textTheme.headlineLarge?.copyWith(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Discover the perfect course to advance your learning journey",
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontSize: 16,
                              color: theme.textTheme.bodyMedium?.color
                                  ?.withOpacity(0.6),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Category Filter Chips
                  Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: categoryFilters.length,
                      itemBuilder: (context, index) {
                        final category = categoryFilters[index];
                        final isSelected = selectedCategory == category;
                        return Container(
                          margin: const EdgeInsets.only(right: 12),
                          child: FilterChip(
                            label: Text(
                              category,
                              style: TextStyle(
                                color: isSelected
                                    ? theme.colorScheme.onPrimary
                                    : primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            selected: isSelected,
                            selectedColor: primary,
                            backgroundColor: theme.cardColor,
                            side: BorderSide(
                              color: isSelected
                                  ? primary
                                  : Theme.of(context).dividerColor,
                            ),
                            onSelected: (bool selected) {
                              setState(() {
                                selectedCategory = category;
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),

                  // Courses Categories
                  ..._filteredCategories.map((category) {
                    return _buildCategorySection(context, category);
                  }).toList(),

                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget _buildCategorySection(
    BuildContext context,
    Map<String, dynamic> category,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Header
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
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${(category["courses"] as List).length} courses available",
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
                    onPressed: () {
                      // Navigate to the dedicated category screen
                      String categoryTitle = category["title"];
                      String targetCategory;

                      // Map category title to filter category
                      if (categoryTitle.contains("JEE")) {
                        if (categoryTitle.contains("Advanced")) {
                          targetCategory = "JEE Advanced";
                        } else {
                          targetCategory = "JEE Mains";
                        }
                      } else if (categoryTitle.contains("NEET")) {
                        targetCategory = "NEET";
                      } else if (categoryTitle.contains("CBSE")) {
                        targetCategory = "CBSE";
                      } else {
                        targetCategory = categoryTitle;
                      }

                      // Navigate to courses category screen
                      Navigator.pushNamed(
                        context,
                        AppRouter.coursesCategory,
                        arguments: {
                          'category': targetCategory,
                          'categoryTitle': categoryTitle,
                        },
                      );
                    },
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
                        fontSize: 14,
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
          const SizedBox(height: 16),

          // Course Cards Carousel
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
                child: _buildModernCourseCard(context, course),
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
              tag: '',
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
                        course["durationText"],
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
                      course["title"],
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
                            course["educatorName"],
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
                      course["description"],
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
                              "₹${course["price"]}",
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
                                  title: course["title"],
                                  educatorName: course["educatorName"],
                                  description: course["description"],
                                  durationText: course["durationText"],
                                  price: course["price"],
                                  oldPrice: course["oldPrice"],
                                  imageUrl: course["imageUrl"],
                                  tag: course["tag"],
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
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
            ),
          ],
        ),
      ),
    );
  }
}
