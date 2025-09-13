import 'package:facultypedia/components/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const Color kPrimaryColor = Color(0xFF4A90E2);

class WebinarsScreen extends StatefulWidget {
  const WebinarsScreen({super.key});

  @override
  State<WebinarsScreen> createState() => _WebinarsScreenState();
}

class _WebinarsScreenState extends State<WebinarsScreen>
    with TickerProviderStateMixin {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, dynamic>> _upcomingWebinars = [
    {
      'title': 'Advanced Mathematics for JEE',
      'instructor': 'Dr. Rajesh Kumar',
      'date': 'Sep 10, 2025',
      'time': '6:00 PM',
      'duration': '2 hours',
      'participants': 450,
      'topic': 'Calculus and Integration',
      'level': 'Advanced',
      'isLive': false,
    },
    {
      'title': 'Physics Problem Solving',
      'instructor': 'Prof. Anita Sharma',
      'date': 'Sep 12, 2025',
      'time': '7:00 PM',
      'duration': '1.5 hours',
      'participants': 320,
      'topic': 'Mechanics and Thermodynamics',
      'level': 'Intermediate',
      'isLive': false,
    },
    {
      'title': 'Chemistry for NEET Preparation',
      'instructor': 'Dr. Suresh Patel',
      'date': 'Sep 15, 2025',
      'time': '5:30 PM',
      'duration': '2.5 hours',
      'participants': 280,
      'topic': 'Organic Chemistry Basics',
      'level': 'Beginner',
      'isLive': false,
    },
  ];

  final List<Map<String, dynamic>> _pastWebinars = [
    {
      'title': 'English Grammar Mastery',
      'instructor': 'Ms. Priya Singh',
      'date': 'Sep 5, 2025',
      'time': '4:00 PM',
      'duration': '2 hours',
      'participants': 520,
      'topic': 'Grammar and Comprehension',
      'level': 'Beginner',
      'isLive': false,
      'recording': true,
    },
    {
      'title': 'Biology for Medical Entrance',
      'instructor': 'Dr. Vikash Gupta',
      'date': 'Sep 3, 2025',
      'time': '6:30 PM',
      'duration': '3 hours',
      'participants': 380,
      'topic': 'Cell Biology and Genetics',
      'level': 'Advanced',
      'isLive': false,
      'recording': true,
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

  List<Map<String, dynamic>> get _filteredUpcomingWebinars {
    if (_searchQuery.isEmpty) return _upcomingWebinars;
    return _upcomingWebinars.where((webinar) {
      return webinar['title'].toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          webinar['instructor'].toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          webinar['topic'].toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  List<Map<String, dynamic>> get _filteredPastWebinars {
    if (_searchQuery.isEmpty) return _pastWebinars;
    return _pastWebinars.where((webinar) {
      return webinar['title'].toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          webinar['instructor'].toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          webinar['topic'].toLowerCase().contains(_searchQuery.toLowerCase());
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
    final primary = theme.colorScheme.primary;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: const CustomDrawer(),
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
            child: Icon(Icons.menu, color: primary, size: 20),
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
                    hintText: 'Search webinars...',
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
            : Text(
                "Webinars",
                style: theme.textTheme.headlineSmall?.copyWith(
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
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: theme.colorScheme.primary.withOpacity(0.2),
                        ),
                      ),
                      child: FaIcon(
                        FontAwesomeIcons.video,
                        color: theme.colorScheme.primary,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Welcome Text
                    Text(
                      "Live Learning Sessions",
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Join interactive webinars with expert educators",
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: 16,
                        color: theme.textTheme.bodyMedium?.color?.withOpacity(
                          0.6,
                        ),
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            // Upcoming Webinars Section
            _buildModernSection(
              "Upcoming Webinars",
              "Join live sessions with expert instructors",
              Column(
                children: _filteredUpcomingWebinars
                    .map((webinar) => _buildWebinarCard(webinar, true))
                    .toList(),
              ),
            ),

            // Past Webinars Section
            _buildModernSection(
              "Past Webinars",
              "Watch recordings of previous sessions",
              Column(
                children: _filteredPastWebinars
                    .map((webinar) => _buildWebinarCard(webinar, false))
                    .toList(),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Implement schedule webinar functionality
          _showScheduleDialog(context);
        },
        backgroundColor: theme.colorScheme.primary,
        icon: Icon(Icons.add, color: theme.colorScheme.onPrimary),
        label: Text(
          "Schedule",
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
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
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 14,
                    color: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.color?.withOpacity(0.6),
                  ),
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

  // Webinar Card Builder
  Widget _buildWebinarCard(Map<String, dynamic> webinar, bool isUpcoming) {
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
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          webinar['title'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "by ${webinar['instructor']}",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isUpcoming
                          ? Colors.green.withOpacity(0.1)
                          : Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isUpcoming
                            ? Colors.green.withOpacity(0.3)
                            : Colors.blue.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      isUpcoming
                          ? "Upcoming"
                          : (webinar['recording'] == true
                                ? "Recording"
                                : "Past"),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isUpcoming
                            ? Colors.green[700]
                            : Colors.blue[700],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Topic
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  webinar['topic'],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: kPrimaryColor,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Details Row
              Row(
                children: [
                  _buildDetailChip(Icons.calendar_today, webinar['date']),
                  const SizedBox(width: 12),
                  _buildDetailChip(Icons.access_time, webinar['time']),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  _buildDetailChip(Icons.timer, webinar['duration']),
                  const SizedBox(width: 12),
                  _buildDetailChip(
                    Icons.people,
                    "${webinar['participants']} joined",
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  _buildDetailChip(Icons.signal_cellular_alt, webinar['level']),
                ],
              ),

              const SizedBox(height: 20),

              // Action Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (isUpcoming) {
                      _joinWebinar(webinar);
                    } else {
                      _watchRecording(webinar);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isUpcoming ? Icons.video_call : Icons.play_arrow,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isUpcoming
                            ? "Join Webinar"
                            : (webinar['recording'] == true
                                  ? "Watch Recording"
                                  : "Details"),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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

  // Join Webinar Function
  void _joinWebinar(Map<String, dynamic> webinar) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Join Webinar"),
        content: Text(
          "You're about to join '${webinar['title']}'. Make sure you have a stable internet connection.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement actual webinar join logic
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Joining webinar...")),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor),
            child: const Text("Join", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Watch Recording Function
  void _watchRecording(Map<String, dynamic> webinar) {
    if (webinar['recording'] == true) {
      // TODO: Implement video player for recordings
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Opening recording...")));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Recording not available")));
    }
  }

  // Schedule Dialog
  void _showScheduleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Schedule Webinar"),
        content: const Text(
          "This feature allows instructors to schedule new webinars. Please contact admin for access.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Navigate to schedule webinar form
            },
            style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor),
            child: const Text(
              "Contact Admin",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
