import 'package:facultypedia/components/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const Color kPrimaryColor = Color(0xFF4A90E2);

class TestSeriesScreen extends StatefulWidget {
  const TestSeriesScreen({super.key});

  @override
  State<TestSeriesScreen> createState() => _TestSeriesScreenState();
}

class _TestSeriesScreenState extends State<TestSeriesScreen>
    with TickerProviderStateMixin {
  String _selectedCategory = 'All';
  String _selectedLevel = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<String> _categories = [
    'All',
    'JEE Main',
    'JEE Advanced',
    'NEET',
    'CBSE',
  ];
  final List<String> _levels = ['All', 'Beginner', 'Intermediate', 'Advanced'];

  final List<Map<String, dynamic>> _testSeries = [
    {
      'id': 1,
      'title': 'JEE Main Physics Mock Test Series',
      'category': 'JEE Main',
      'level': 'Intermediate',
      'instructor': 'Dr. Rajesh Kumar',
      'totalTests': 25,
      'completedTests': 8,
      'duration': 180, // minutes
      'questions': 30,
      'price': 999,
      'rating': 4.8,
      'students': 2450,
      'topics': ['Mechanics', 'Thermodynamics', 'Optics', 'Modern Physics'],
      'description':
          'Comprehensive physics test series covering all JEE Main topics with detailed solutions.',
      'features': [
        'Video Solutions',
        'Performance Analytics',
        'Rank Prediction',
        'Mobile App',
      ],
      'isEnrolled': true,
      'isPremium': false,
    },
    {
      'id': 2,
      'title': 'NEET Biology Complete Test Series',
      'category': 'NEET',
      'level': 'Advanced',
      'instructor': 'Dr. Priya Sharma',
      'totalTests': 30,
      'completedTests': 0,
      'duration': 180,
      'questions': 45,
      'price': 1499,
      'rating': 4.9,
      'students': 3200,
      'topics': ['Botany', 'Zoology', 'Human Physiology', 'Genetics'],
      'description':
          'Most comprehensive NEET biology test series with latest pattern questions.',
      'features': [
        'NCERT Based',
        'Previous Years',
        'Mock Tests',
        'Doubt Support',
      ],
      'isEnrolled': false,
      'isPremium': true,
    },
    {
      'id': 3,
      'title': 'JEE Advanced Mathematics',
      'category': 'JEE Advanced',
      'level': 'Advanced',
      'instructor': 'Prof. Ankit Singh',
      'totalTests': 20,
      'completedTests': 5,
      'duration': 180,
      'questions': 18,
      'price': 1999,
      'rating': 4.7,
      'students': 1800,
      'topics': ['Calculus', 'Algebra', 'Coordinate Geometry', 'Trigonometry'],
      'description':
          'Advanced level mathematics test series for JEE Advanced preparation.',
      'features': [
        'Subjective Questions',
        'Step-by-step Solutions',
        'Concept Videos',
        'Live Doubt',
      ],
      'isEnrolled': true,
      'isPremium': true,
    },
    {
      'id': 4,
      'title': 'CBSE Class 12 Chemistry',
      'category': 'CBSE',
      'level': 'Beginner',
      'instructor': 'Ms. Kavya Patel',
      'totalTests': 15,
      'completedTests': 12,
      'duration': 120,
      'questions': 25,
      'price': 599,
      'rating': 4.6,
      'students': 5600,
      'topics': [
        'Organic Chemistry',
        'Physical Chemistry',
        'Inorganic Chemistry',
      ],
      'description':
          'Complete CBSE Class 12 chemistry test series aligned with board pattern.',
      'features': [
        'Board Pattern',
        'Sample Papers',
        'Chapter Tests',
        'Final Revision',
      ],
      'isEnrolled': true,
      'isPremium': false,
    },
    {
      'id': 5,
      'title': 'NEET Physics Crash Course Tests',
      'category': 'NEET',
      'level': 'Intermediate',
      'instructor': 'Dr. Vikash Gupta',
      'totalTests': 18,
      'completedTests': 0,
      'duration': 150,
      'questions': 35,
      'price': 799,
      'rating': 4.5,
      'students': 2100,
      'topics': ['Mechanics', 'Electricity', 'Magnetism', 'Modern Physics'],
      'description':
          'Intensive physics test series designed for NEET crash course students.',
      'features': [
        'Quick Tests',
        'Instant Results',
        'Error Analysis',
        'Study Material',
      ],
      'isEnrolled': false,
      'isPremium': false,
    },
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
  }

  List<Map<String, dynamic>> get _filteredTests {
    return _testSeries.where((test) {
      bool categoryMatch =
          _selectedCategory == 'All' || test['category'] == _selectedCategory;
      bool levelMatch =
          _selectedLevel == 'All' || test['level'] == _selectedLevel;
      bool searchMatch =
          _searchQuery.isEmpty ||
          test['title'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          test['instructor'].toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          test['topics'].any(
            (topic) => topic.toLowerCase().contains(_searchQuery.toLowerCase()),
          );
      return categoryMatch && levelMatch && searchMatch;
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

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.grey[50],
      drawer: const CustomDrawer(),
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
            child: Icon(Icons.menu, color: kPrimaryColor, size: 20),
          ),
          onPressed: () => scaffoldKey.currentState?.openDrawer(),
        ),
        title: _isSearchExpanded
            ? FadeTransition(
                opacity: _fadeAnimation,
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Search test series...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey[500]),
                  ),
                  style: const TextStyle(color: Colors.black87, fontSize: 16),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              )
            : const Text(
                "Test Series",
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
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
              child: Icon(
                _isSearchExpanded ? Icons.close : Icons.search,
                color: kPrimaryColor,
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
                  colors: [Colors.white, kPrimaryColor.withOpacity(0.05)],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                child: Column(
                  children: [
                    // Welcome Icon
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: kPrimaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: kPrimaryColor.withOpacity(0.2),
                        ),
                      ),
                      child: FaIcon(
                        FontAwesomeIcons.clipboardList,
                        color: kPrimaryColor,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Welcome Text
                    const Text(
                      "Test Your Knowledge",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Practice with comprehensive test series and track your progress",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            // Filters Section
            _buildModernSection(
              "Filters",
              "Find the perfect test series for your needs",
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Card(
                  elevation: 8,
                  shadowColor: Colors.black.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.white, kPrimaryColor.withOpacity(0.02)],
                      ),
                    ),
                    child: Column(
                      children: [
                        // Category Filter
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Category",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _categories.map((category) {
                                bool isSelected = _selectedCategory == category;
                                return GestureDetector(
                                  onTap: () => setState(
                                    () => _selectedCategory = category,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? kPrimaryColor
                                          : Colors.grey[100],
                                      borderRadius: BorderRadius.circular(25),
                                      border: Border.all(
                                        color: isSelected
                                            ? kPrimaryColor
                                            : Colors.grey[300]!,
                                      ),
                                    ),
                                    child: Text(
                                      category,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.grey[700],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Level Filter
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Level",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _levels.map((level) {
                                bool isSelected = _selectedLevel == level;
                                return GestureDetector(
                                  onTap: () =>
                                      setState(() => _selectedLevel = level),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? kPrimaryColor
                                          : Colors.grey[100],
                                      borderRadius: BorderRadius.circular(25),
                                      border: Border.all(
                                        color: isSelected
                                            ? kPrimaryColor
                                            : Colors.grey[300]!,
                                      ),
                                    ),
                                    child: Text(
                                      level,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.grey[700],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Test Series Section
            _buildModernSection(
              "Available Test Series",
              "Choose from ${_filteredTests.length} test series",
              Column(
                children: _filteredTests
                    .map((test) => _buildTestSeriesCard(test))
                    .toList(),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showMyTestsDialog(context);
        },
        backgroundColor: kPrimaryColor,
        icon: const Icon(Icons.assignment, color: Colors.white),
        label: const Text(
          "My Tests",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  // Modern Section Builder
  Widget _buildModernSection(String title, String subtitle, Widget content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
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
          const SizedBox(height: 20),

          // Section Content
          content,
        ],
      ),
    );
  }

  // Test Series Card Builder
  Widget _buildTestSeriesCard(Map<String, dynamic> test) {
    double progress = test['completedTests'] / test['totalTests'];

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Card(
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, kPrimaryColor.withOpacity(0.02)],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                test['title'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (test['isPremium'])
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.amber, Colors.orange],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  "PREMIUM",
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "by ${test['instructor']}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Price and Rating
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "₹${test['price']}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            "${test['rating']}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Progress Bar (if enrolled)
              if (test['isEnrolled']) ...[
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Progress",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                "${test['completedTests']}/${test['totalTests']} tests",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              kPrimaryColor,
                            ),
                            minHeight: 6,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],

              // Category and Level badges
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildBadge(test['category'], kPrimaryColor),
                  _buildBadge(test['level'], _getLevelColor(test['level'])),
                ],
              ),

              const SizedBox(height: 12),

              // Test Details
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildDetailChip(
                    Icons.quiz,
                    "${test['questions']} questions",
                  ),
                  _buildDetailChip(Icons.timer, "${test['duration']} min"),
                  _buildDetailChip(
                    Icons.people,
                    "${test['students']} students",
                  ),
                  _buildDetailChip(
                    Icons.assignment,
                    "${test['totalTests']} tests",
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Description
              Text(
                test['description'],
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 16),

              // Features
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: test['features'].map<Widget>((feature) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.withOpacity(0.3)),
                    ),
                    child: Text(
                      feature,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.green[700],
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              // Action Buttons
              if (test['isEnrolled']) ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _startTest(test),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      "Continue Tests",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ] else ...[
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _enrollTest(test),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          "Enroll Now",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => _previewTest(test),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: kPrimaryColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          "Preview",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // Badge Builder
  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color.withOpacity(0.8),
        ),
      ),
    );
  }

  // Detail Chip Builder
  Widget _buildDetailChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Get Level Color
  Color _getLevelColor(String level) {
    switch (level) {
      case 'Beginner':
        return Colors.green;
      case 'Intermediate':
        return Colors.orange;
      case 'Advanced':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Start Test Function
  void _startTest(Map<String, dynamic> test) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Start Test"),
        content: SizedBox(
          width: double.maxFinite,
          child: Text(
            "Continue with '${test['title']}'? You can resume from where you left off.",
            style: const TextStyle(fontSize: 14),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Navigate to test screen
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("Starting test...")));
            },
            style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor),
            child: const Text("Start", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Enroll Test Function
  void _enrollTest(Map<String, dynamic> test) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Enroll in Test Series"),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Test Series: ${test['title']}",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text("Price: ₹${test['price']}"),
                Text("Total Tests: ${test['totalTests']}"),
                const SizedBox(height: 16),
                const Text(
                  "Features included:",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                ...test['features'].map<Widget>(
                  (feature) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text("• $feature"),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement payment gateway
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Redirecting to payment...")),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor),
            child: const Text(
              "Proceed to Pay",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // Preview Test Function
  void _previewTest(Map<String, dynamic> test) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Test Preview"),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Test Series: ${test['title']}",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Text("Instructor: ${test['instructor']}"),
                const SizedBox(height: 4),
                Text("Category: ${test['category']}"),
                const SizedBox(height: 4),
                Text("Level: ${test['level']}"),
                const SizedBox(height: 4),
                Text("Duration: ${test['duration']} minutes"),
                const SizedBox(height: 4),
                Text("Questions: ${test['questions']} per test"),
                const SizedBox(height: 4),
                Text("Total Tests: ${test['totalTests']}"),
                const SizedBox(height: 12),
                const Text(
                  "Sample Topics:",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                ...test['topics']
                    .take(3)
                    .map<Widget>(
                      (topic) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text("• $topic"),
                      ),
                    ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _enrollTest(test);
            },
            style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor),
            child: const Text(
              "Enroll Now",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // My Tests Dialog
  void _showMyTestsDialog(BuildContext context) {
    final enrolledTests = _testSeries
        .where((test) => test['isEnrolled'])
        .toList();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("My Test Series"),
        content: SizedBox(
          width: double.maxFinite,
          child: enrolledTests.isEmpty
              ? const Text("You haven't enrolled in any test series yet.")
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: enrolledTests.length,
                  itemBuilder: (context, index) {
                    final test = enrolledTests[index];
                    double progress =
                        test['completedTests'] / test['totalTests'];
                    return ListTile(
                      title: Text(
                        test['title'],
                        style: const TextStyle(fontSize: 14),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${test['completedTests']}/${test['totalTests']} tests completed",
                          ),
                          const SizedBox(height: 4),
                          LinearProgressIndicator(
                            value: progress,
                            minHeight: 4,
                          ),
                        ],
                      ),
                      trailing: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _startTest(test);
                        },
                        child: const Text("Continue"),
                      ),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }
}
