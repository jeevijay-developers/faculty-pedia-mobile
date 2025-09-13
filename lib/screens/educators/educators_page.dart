import 'package:facultypedia/components/custom_drawer.dart';
import 'package:facultypedia/screens/educators/educator_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/educator_model.dart';
import 'bloc/educator_bloc.dart';
import 'bloc/educator_event.dart';
import 'bloc/educator_state.dart';
import 'repository/educator_repository.dart';

const Color kPrimaryColor = Color(0xFF4A90E2);

class EducatorsPage extends StatelessWidget {
  final String? preselectedCategory;

  const EducatorsPage({super.key, this.preselectedCategory});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final token = snapshot.data;
        if (token == null) {
          return const Scaffold(
            body: Center(child: Text('Authentication required')),
          );
        }

        return BlocProvider(
          create: (context) =>
              EducatorBloc(repository: EducatorRepository(token: token))
                ..add(FetchEducators()),
          child: _EducatorsPageContent(
            preselectedCategory: preselectedCategory,
          ),
        );
      },
    );
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}

class _EducatorsPageContent extends StatefulWidget {
  final String? preselectedCategory;

  const _EducatorsPageContent({this.preselectedCategory});

  @override
  State<_EducatorsPageContent> createState() => _EducatorsPageContentState();
}

class _EducatorsPageContentState extends State<_EducatorsPageContent>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  String selectedCategory = "All";
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _chipsScrollController = ScrollController();
  bool _isSearchExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<String> categories = [
    "All",
    "Math",
    "Physics",
    "Chemistry",
    "Biology",
    "NEET",
    "IIT-JEE",
    "CBSE",
  ];
  @override
  void dispose() {
    _searchController.dispose();
    _chipsScrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // Map common category names to our internal categories
  String _mapCategoryName(String category) {
    switch (category.toLowerCase()) {
      case 'iit':
        return 'IIT-JEE';
      case 'mathematics':
        return 'Math';
      default:
        return category;
    }
  }

  // Auto-scroll to the selected category chip
  void _scrollToSelectedChip() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_chipsScrollController.hasClients) {
        final selectedIndex = categories.indexOf(selectedCategory);
        if (selectedIndex != -1) {
          // Calculate approximate position of the chip
          // Each chip is approximately 100-120 pixels wide with margins
          final chipWidth = 120.0;
          final targetPosition = selectedIndex * chipWidth;
          final maxScrollExtent =
              _chipsScrollController.position.maxScrollExtent;
          final scrollPosition = (targetPosition - 100).clamp(
            0.0,
            maxScrollExtent,
          );

          _chipsScrollController.animateTo(
            scrollPosition,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

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
    if (widget.preselectedCategory != null) {
      // Map common category names to our internal categories
      String mappedCategory = _mapCategoryName(widget.preselectedCategory!);
      if (categories.contains(mappedCategory)) {
        selectedCategory = mappedCategory;
        // Auto-scroll to the selected chip after the widget is built
        _scrollToSelectedChip();
      }
    }

    // Load educators using BLoC
    context.read<EducatorBloc>().add(FetchEducators());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<EducatorBloc, EducatorState>(
      builder: (context, state) {
        // Get educators list from state
        List<Educator> educators = [];
        bool isLoading = false;
        String? error;

        if (state is EducatorLoading) {
          isLoading = true;
        } else if (state is EducatorLoaded) {
          educators = state.educators;
        } else if (state is EducatorError) {
          error = state.message;
        }

        // 🔹 Filter educators based on selected category and search query
        final filteredEducators = educators.where((e) {
          bool categoryMatch = selectedCategory == "All";

          if (!categoryMatch) {
            String selectedLower = selectedCategory.toLowerCase();
            String subjectLower = e.subject.toLowerCase();
            String? specializationLower = e.specialization?.toLowerCase();

            // Check exact match or specific known mappings
            categoryMatch =
                subjectLower == selectedLower ||
                (selectedLower == "math" && subjectLower == "mathematics") ||
                (selectedLower == "mathematics" && subjectLower == "math") ||
                specializationLower == selectedLower;
          }

          bool searchMatch =
              _searchQuery.isEmpty ||
              e.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              e.subject.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              (e.bio?.toLowerCase().contains(_searchQuery.toLowerCase()) ??
                  false) ||
              (e.specialization?.toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  ) ??
                  false);

          return categoryMatch && searchMatch;
        }).toList();

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
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  widget.preselectedCategory != null
                      ? Icons.arrow_back
                      : Icons.menu,
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
                        hintText: 'Search educators...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: theme.dividerColor),
                      ),
                      style: theme.textTheme.bodyLarge?.copyWith(fontSize: 16),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                  )
                : Container(
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
          drawer: widget.preselectedCategory != null
              ? null
              : const CustomDrawer(),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.grey.shade50,
                  Colors.white,
                  Colors.grey.shade50,
                ],
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Enhanced Hero Section
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white,
                          kPrimaryColor.withOpacity(0.08),
                          kPrimaryColor.withOpacity(0.03),
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 36),
                      child: Column(
                        children: [
                          // Enhanced Title with Icon
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: kPrimaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: kPrimaryColor.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: kPrimaryColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Icon(
                                    Icons.school_rounded,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Expert Educators",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: kPrimaryColor,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Learn from the Best Minds",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: Colors.black87,
                              letterSpacing: -0.8,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            constraints: const BoxConstraints(maxWidth: 280),
                            child: Text(
                              "Connect with industry experts and experienced educators who are passionate about sharing knowledge",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                                height: 1.5,
                                letterSpacing: 0.1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Category Filter Section
                  _buildModernSection(
                    "Subject Categories",
                    "Filter educators by their expertise",
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      controller: _chipsScrollController,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: categories.map((category) {
                            final isSelected = selectedCategory == category;
                            return Container(
                              margin: const EdgeInsets.only(right: 14),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectedCategory = category;
                                    });
                                    // Reload educators for new category using BLoC
                                    context.read<EducatorBloc>().add(
                                      FetchEducators(),
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(30),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 14,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: isSelected
                                          ? LinearGradient(
                                              colors: [
                                                kPrimaryColor,
                                                kPrimaryColor.withBlue(255),
                                              ],
                                            )
                                          : null,
                                      color: isSelected ? null : Colors.white,
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                        color: isSelected
                                            ? Colors.transparent
                                            : Colors.grey.withOpacity(0.15),
                                        width: 1,
                                      ),
                                      boxShadow: isSelected
                                          ? [
                                              BoxShadow(
                                                color: kPrimaryColor
                                                    .withOpacity(0.25),
                                                blurRadius: 8,
                                                offset: const Offset(0, 3),
                                                spreadRadius: 0,
                                              ),
                                            ]
                                          : [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                  0.04,
                                                ),
                                                blurRadius: 6,
                                                offset: const Offset(0, 2),
                                                spreadRadius: 0,
                                              ),
                                            ],
                                    ),
                                    child: Text(
                                      category,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        letterSpacing: 0.3,
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.black87,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),

                  // Educators Grid Section
                  _buildModernSection(
                    isLoading
                        ? "Loading Educators..."
                        : "${filteredEducators.length} Expert${filteredEducators.length != 1 ? 's' : ''} Available",
                    selectedCategory == "All"
                        ? "Discover all our professional educators"
                        : "Specialists in $selectedCategory",
                    isLoading
                        ? Container(
                            height: 200,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: kPrimaryColor,
                              ),
                            ),
                          )
                        : error != null
                        ? Container(
                            height: 200,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    size: 48,
                                    color: Colors.red[400],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    "Error loading educators",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.red[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    error,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[500],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: () => context
                                        .read<EducatorBloc>()
                                        .add(FetchEducators()),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: kPrimaryColor,
                                    ),
                                    child: Text(
                                      'Retry',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : filteredEducators.isEmpty
                        ? Container(
                            height: 200,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.search_off,
                                    size: 48,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    "No educators found",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Try selecting a different category",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.78,
                                    crossAxisSpacing: 14,
                                    mainAxisSpacing: 14,
                                  ),
                              itemCount: filteredEducators.length,
                              itemBuilder: (context, index) {
                                final educator = filteredEducators[index];
                                // Use subject if available, otherwise use specialization, otherwise use "General"
                                String displaySubject =
                                    educator.subject.isNotEmpty
                                    ? educator.subject
                                    : (educator.specialization?.isNotEmpty ==
                                              true
                                          ? educator.specialization!
                                          : "General");

                                return _buildModernEducatorCard(
                                  educator.name,
                                  displaySubject,
                                  educator.experience ?? 'N/A',
                                  educator.experience ?? 'N/A',
                                  educator.bio ?? 'No description available',
                                  educator.image?.url ??
                                      'https://placehold.co/150.png',
                                  educator.rating ?? 0.0,
                                  0, // reviews - not in model
                                  () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EducatorProfilePage(
                                              id: educator.id,
                                              name: educator.name,
                                              subject: displaySubject,
                                              description:
                                                  educator.bio ??
                                                  'No description available',
                                              education: 'N/A', // not in model
                                              experience:
                                                  educator.experience ?? 'N/A',
                                              rating: educator.rating ?? 0.0,
                                              reviews: 0, // not in model
                                              followers:
                                                  educator.totalFollowers ?? 0,
                                              tag: displaySubject,
                                              imageUrl:
                                                  educator.image?.url ??
                                                  'https://placehold.co/150.png',
                                              youtubeUrl: 'N/A', // not in model
                                              email: educator.email,
                                              phone: 'N/A', // not in model
                                              socialLinks: {}, // not in model
                                            ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildModernSection(String title, String subtitle, Widget content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Modern Section Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 24,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [kPrimaryColor, kPrimaryColor.withBlue(255)],
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                          letterSpacing: -0.8,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
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

  Widget _buildModernEducatorCard(
    String name,
    String subject,
    String education,
    String experience,
    String description,
    String imageUrl,
    double rating,
    int reviews,
    VoidCallback onTap,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Colors.grey.shade50],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 25,
            offset: const Offset(0, 10),
            spreadRadius: -5,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Column(
              children: [
                // Modern Profile Section - Made flexible
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(
                    minHeight: 130,
                    maxHeight: 160,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        kPrimaryColor.withOpacity(0.1),
                        Colors.blue.shade100.withOpacity(0.3),
                        Colors.purple.shade50.withOpacity(0.2),
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Decorative circles
                      Positioned(
                        top: -20,
                        right: -20,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -10,
                        left: -10,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: kPrimaryColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),

                      // Profile image and content - Made flexible
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Profile Avatar
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey.shade200,
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.grey.shade400,
                                        size: 30,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),

                            // Name - Fixed overflow
                            Flexible(
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                child: Text(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                    height: 1.2,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),

                            // Subject tag - Fixed overflow
                            if (subject.isNotEmpty)
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                constraints: const BoxConstraints(
                                  maxWidth: 120,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: kPrimaryColor,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  subject,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                          ],
                        ),
                      ),

                      // Rating badge - only show if rating > 0
                      if (rating > 0)
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.amber.shade600,
                                  size: 14,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  rating.toStringAsFixed(1),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Content Section - Fixed overflow issues
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Description - Better height management
                        Expanded(
                          flex: 2,
                          child: Container(
                            width: double.infinity,
                            child: Text(
                              description,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                                height: 1.3,
                              ),
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),

                        // Fixed height spacer
                        const SizedBox(height: 8),

                        // Experience and Action Row - Fixed overflow
                        Container(
                          height: 32,
                          child: Row(
                            children: [
                              // Experience - Flexible width
                              if (experience.isNotEmpty && experience != 'N/A')
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade50,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: Colors.green.shade200,
                                        width: 0.5,
                                      ),
                                    ),
                                    child: Text(
                                      experience,
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.green.shade700,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),

                              // Spacing
                              SizedBox(
                                width:
                                    experience.isNotEmpty && experience != 'N/A'
                                    ? 6
                                    : 0,
                              ),

                              // View Profile Button - Fixed width
                              Container(
                                height: 32,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      kPrimaryColor,
                                      kPrimaryColor.withBlue(255),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: kPrimaryColor.withOpacity(0.2),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Text(
                                  "View",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
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
      ),
    );
  }
}
