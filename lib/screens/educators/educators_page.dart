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
                child: Icon(
                  widget.preselectedCategory != null
                      ? Icons.arrow_back
                      : Icons.menu,
                  color: kPrimaryColor,
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
                        hintStyle: TextStyle(color: Colors.grey[500]),
                      ),
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                      ),
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
          drawer: widget.preselectedCategory != null
              ? null
              : const CustomDrawer(),
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
                        Text(
                          "👩‍🏫 Our Expert Educators",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Learn from industry experts and experienced educators",
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
                            margin: const EdgeInsets.only(right: 12),
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
                              borderRadius: BorderRadius.circular(25),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? kPrimaryColor
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(
                                    color: isSelected
                                        ? kPrimaryColor
                                        : Colors.grey.withOpacity(0.3),
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  category,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black87,
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
                                  childAspectRatio: 0.65,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                ),
                            itemCount: filteredEducators.length,
                            itemBuilder: (context, index) {
                              final educator = filteredEducators[index];
                              // Use subject if available, otherwise use specialization, otherwise use "General"
                              String displaySubject =
                                  educator.subject.isNotEmpty
                                  ? educator.subject
                                  : (educator.specialization?.isNotEmpty == true
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
                                      builder: (context) => EducatorProfilePage(
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
                                        followers: educator.totalFollowers ?? 0,
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
          // Section Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
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
    return GestureDetector(
      onTap: onTap,
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
            // Educator Image
            Container(
              height: 100,
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
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, size: 12, color: Colors.amber[600]),
                          const SizedBox(width: 2),
                          Text(
                            rating.toString(),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (subject.isNotEmpty)
                    Positioned(
                      bottom: 8,
                      left: 8,
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
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Educator Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      education,
                      style: TextStyle(
                        fontSize: 9,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            experience,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: kPrimaryColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            "View",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
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
