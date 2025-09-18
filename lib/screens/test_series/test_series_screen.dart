import 'package:facultypedia/components/custom_drawer.dart';
import 'package:facultypedia/router/router.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TestSeriesScreen extends StatefulWidget {
  final String? preselectedCategory;

  const TestSeriesScreen({super.key, this.preselectedCategory});

  @override
  State<TestSeriesScreen> createState() => _TestSeriesScreenState();
}

class _TestSeriesScreenState extends State<TestSeriesScreen>
    with TickerProviderStateMixin {
  String _selectedCategory = 'All';
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

  final List<Map<String, dynamic>> _testSeries = [
    {
      'id': 1,
      'title': 'JEE Main Physics Mock Test Series',
      'category': 'JEE Main',
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

    if (widget.preselectedCategory != null) {
      String mappedCategory = _mapCategoryToTestSeries(
        widget.preselectedCategory!,
      );
      if (_categories.contains(mappedCategory)) {
        _selectedCategory = mappedCategory;
      }
    }
  }

  String _mapCategoryToTestSeries(String category) {
    switch (category) {
      case 'IIT':
        return 'JEE Advanced';
      case 'JEE Advanced':
        return 'JEE Advanced';
      case 'NEET':
        return 'NEET';
      case 'CBSE':
        return 'CBSE';
      default:
        return category;
    }
  }

  List<Map<String, dynamic>> get _filteredTests {
    return _testSeries.where((test) {
      bool categoryMatch =
          _selectedCategory == 'All' || test['category'] == _selectedCategory;

      bool searchMatch =
          _searchQuery.isEmpty ||
          test['title'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          test['instructor'].toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          test['topics'].any(
            (topic) => topic.toLowerCase().contains(_searchQuery.toLowerCase()),
          );
      return categoryMatch && searchMatch;
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
      key: scaffoldKey,
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: widget.preselectedCategory != null ? null : const CustomDrawer(),
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
            child: Icon(
              widget.preselectedCategory != null
                  ? Icons.arrow_back
                  : Icons.menu,
              color: primaryColor,
              size: 20,
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
                    hintText: 'Search test series...',
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
            : Text(
                "Test Series",
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: primaryColor.withOpacity(0.2),
                        ),
                      ),
                      child: FaIcon(
                        FontAwesomeIcons.clipboardList,
                        color: primaryColor,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Test Your Knowledge",
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Practice with comprehensive test series and track your progress",
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.hintColor,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            _buildModernSection(
              theme,
              "Filters",
              "Find the perfect test series for your needs",
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Card(
                  elevation: 8,
                  shadowColor: theme.shadowColor.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: theme.cardColor,
                    ),
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Category",
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _categories.map((category) {
                                return ChoiceChip(
                                  label: Text(category),
                                  selected: _selectedCategory == category,
                                  onSelected: (selected) {
                                    if (selected) {
                                      setState(() {
                                        _selectedCategory = category;
                                      });
                                    }
                                  },
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
            _buildModernSection(
              theme,
              "Available Test Series",
              "Choose from ${_filteredTests.length} test series",
              Column(
                children: _filteredTests
                    .map((test) => _buildTestSeriesCard(test, theme))
                    .toList(),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showMyTestsDialog(context, theme);
        },
        backgroundColor: primaryColor,
        icon: Icon(Icons.assignment, color: theme.colorScheme.onPrimary),
        label: Text(
          "My Tests",
          style: TextStyle(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildModernSection(
    ThemeData theme,
    String title,
    String subtitle,
    Widget content,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
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
          const SizedBox(height: 20),
          content,
        ],
      ),
    );
  }

  Widget _buildTestSeriesCard(Map<String, dynamic> test, ThemeData theme) {
    double progress = test['completedTests'] / test['totalTests'];

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Card(
        elevation: 8,
        shadowColor: theme.shadowColor.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: theme.cardColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
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
                                  gradient: const LinearGradient(
                                    colors: [Colors.amber, Colors.orange],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  "PREMIUM",
                                  style: theme.textTheme.bodySmall?.copyWith(
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
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.hintColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "₹${test['price']}",
                        style: theme.textTheme.titleLarge?.copyWith(
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
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.hintColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
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
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.hintColor,
                                ),
                              ),
                              Text(
                                "${test['completedTests']}/${test['totalTests']} tests",
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.hintColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: progress,
                            backgroundColor: theme.dividerColor,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              theme.colorScheme.primary,
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
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildBadge(
                    theme,
                    test['category'],
                    theme.colorScheme.primary,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildDetailChip(
                    theme,
                    Icons.quiz,
                    "${test['questions']} questions",
                  ),
                  _buildDetailChip(
                    theme,
                    Icons.timer,
                    "${test['duration']} min",
                  ),
                  _buildDetailChip(
                    theme,
                    Icons.people,
                    "${test['students']} students",
                  ),
                  _buildDetailChip(
                    theme,
                    Icons.assignment,
                    "${test['totalTests']} tests",
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                test['description'],
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.4,
                  color: theme.hintColor,
                ),
              ),
              const SizedBox(height: 16),
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
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.green[700],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              if (test['isEnrolled']) ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _startTest(test, theme),
                    child: const Text("Continue Tests"),
                  ),
                ),
              ] else ...[
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _enrollTest(test, theme),
                        child: const Text("Enroll Now"),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => _previewTest(test, theme),
                        child: const Text("Preview"),
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

  Widget _buildBadge(ThemeData theme, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: color.withOpacity(0.8),
        ),
      ),
    );
  }

  Widget _buildDetailChip(ThemeData theme, IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.dividerColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: theme.hintColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
          ),
        ],
      ),
    );
  }

  void _startTest(Map<String, dynamic> test, ThemeData theme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Start Test", style: theme.textTheme.headlineSmall),
        content: Text(
          "Continue with '${test['title']}'? You can resume from where you left off.",
          style: theme.textTheme.bodyLarge,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("Starting test...")));
            },
            child: const Text("Start"),
          ),
        ],
      ),
    );
  }

  void _enrollTest(Map<String, dynamic> test, ThemeData theme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          "Enroll in Test Series",
          style: theme.textTheme.headlineSmall,
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Test Series: ${test['title']}",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Price: ₹${test['price']}",
                  style: theme.textTheme.bodyLarge,
                ),
                Text(
                  "Total Tests: ${test['totalTests']}",
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                Text(
                  "Features included:",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                ...test['features'].map<Widget>(
                  (feature) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text("• $feature", style: theme.textTheme.bodyLarge),
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
              // Navigate to payment screen
              AppRouter.navigateToPayment(
                context,
                itemTitle: test['title'],
                itemDescription:
                    'Test Series - ${test['totalTests']} tests included with detailed analysis',
                amount: test['price'].toDouble(),
                imageUrl: test['image'],
              );
            },
            child: const Text("Proceed to Pay"),
          ),
        ],
      ),
    );
  }

  void _previewTest(Map<String, dynamic> test, ThemeData theme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Test Preview", style: theme.textTheme.headlineSmall),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Test Series: ${test['title']}",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Instructor: ${test['instructor']}",
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  "Category: ${test['category']}",
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  "Duration: ${test['duration']} minutes",
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  "Questions: ${test['questions']} per test",
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  "Total Tests: ${test['totalTests']}",
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 12),
                Text(
                  "Sample Topics:",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                ...test['topics']
                    .take(3)
                    .map<Widget>(
                      (topic) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          "• $topic",
                          style: theme.textTheme.bodyLarge,
                        ),
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
              _enrollTest(test, theme);
            },
            child: const Text("Enroll Now"),
          ),
        ],
      ),
    );
  }

  void _showMyTestsDialog(BuildContext context, ThemeData theme) {
    final enrolledTests = _testSeries
        .where((test) => test['isEnrolled'])
        .toList();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("My Test Series", style: theme.textTheme.headlineSmall),
        content: SizedBox(
          width: double.maxFinite,
          child: enrolledTests.isEmpty
              ? Text(
                  "You haven't enrolled in any test series yet.",
                  style: theme.textTheme.bodyLarge,
                )
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
                        style: theme.textTheme.bodyLarge,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${test['completedTests']}/${test['totalTests']} tests completed",
                            style: theme.textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 4),
                          LinearProgressIndicator(
                            value: progress,
                            minHeight: 4,
                            backgroundColor: theme.dividerColor,
                          ),
                        ],
                      ),
                      trailing: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _startTest(test, theme);
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
