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

class EducatorsPage extends StatelessWidget {
  final String? preselectedCategory;

  const EducatorsPage({super.key, this.preselectedCategory});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FutureBuilder<String?>(
      future: _getToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            body: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  theme.colorScheme.primary,
                ),
              ),
            ),
          );
        }

        final token = snapshot.data;
        if (token == null) {
          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            body: Center(
              child: Text(
                'Authentication required',
                style: theme.textTheme.bodyLarge,
              ),
            ),
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

  void _scrollToSelectedChip() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_chipsScrollController.hasClients) {
        final selectedIndex = categories.indexOf(selectedCategory);
        if (selectedIndex != -1) {
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

    if (widget.preselectedCategory != null) {
      String mappedCategory = _mapCategoryName(widget.preselectedCategory!);
      if (categories.contains(mappedCategory)) {
        selectedCategory = mappedCategory;
        _scrollToSelectedChip();
      }
    }

    context.read<EducatorBloc>().add(FetchEducators());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return BlocBuilder<EducatorBloc, EducatorState>(
      builder: (context, state) {
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

        final filteredEducators = educators.where((e) {
          bool categoryMatch = selectedCategory == "All";

          if (!categoryMatch) {
            String selectedLower = selectedCategory.toLowerCase();
            String subjectLower = e.subject.toLowerCase();
            String? specializationLower = e.specialization?.toLowerCase();

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
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  widget.preselectedCategory != null
                      ? Icons.arrow_back
                      : Icons.menu,
                  color: primaryColor,
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
                : SizedBox(
                    height: 40,
                    child: Image.asset("assets/images/fp.png"),
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
          drawer: widget.preselectedCategory != null
              ? null
              : const CustomDrawer(),
          body: SingleChildScrollView(
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
                        theme.cardColor,
                        primaryColor.withOpacity(0.08),
                        primaryColor.withOpacity(0.03),
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
                            color: primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: primaryColor.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Icon(
                                  Icons.school_rounded,
                                  color: theme.colorScheme.onPrimary,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Expert Educators",
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Learn from the Best Minds",
                          textAlign: TextAlign.center,
                          style: theme.textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.w800,
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
                            style: theme.textTheme.bodyLarge?.copyWith(
                              height: 1.5,
                              color: theme.textTheme.bodyMedium?.color
                                  ?.withOpacity(0.7),
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
                          return Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: FilterChip(
                              label: Text(category),
                              selected: selectedCategory == category,
                              onSelected: (selected) {
                                if (selected) {
                                  setState(() {
                                    selectedCategory = category;
                                  });
                                }
                              },
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
                      ? SizedBox(
                          height: 200,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: primaryColor,
                            ),
                          ),
                        )
                      : error != null
                      ? SizedBox(
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
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: Colors.red[600],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  error,
                                  style: theme.textTheme.bodyMedium,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () => context
                                      .read<EducatorBloc>()
                                      .add(FetchEducators()),
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          ),
                        )
                      : filteredEducators.isEmpty
                      ? SizedBox(
                          height: 200,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 48,
                                  color: theme.hintColor,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "No educators found",
                                  style: theme.textTheme.titleMedium,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Try selecting a different category",
                                  style: theme.textTheme.bodyMedium,
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
                              String displaySubject =
                                  educator.subject.isNotEmpty
                                  ? educator.subject
                                  : (educator.specialization?.isNotEmpty == true
                                        ? educator.specialization!
                                        : "General");

                              return _buildModernEducatorCard(
                                theme,
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
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildModernSection(String title, String subtitle, Widget content) {
    final theme = Theme.of(context);
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
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 24,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
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
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.textTheme.bodyMedium?.color?.withOpacity(
                        0.7,
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
    ThemeData theme,
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
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.08),
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
                        theme.colorScheme.primary.withOpacity(0.1),
                        theme.colorScheme.primary.withOpacity(0.2),
                        theme.colorScheme.primary.withOpacity(0.05),
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
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
                                    color: theme.shadowColor.withOpacity(0.1),
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
                                      color: theme.dividerColor,
                                      child: Icon(
                                        Icons.person,
                                        color: theme.hintColor,
                                        size: 30,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Flexible(
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                child: Text(
                                  name,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    height: 1.2,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
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
                                  color: theme.colorScheme.primary,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  subject,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onPrimary,
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
                              color: theme.cardColor,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: theme.shadowColor.withOpacity(0.1),
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
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: SizedBox(
                            width: double.infinity,
                            child: Text(
                              description,
                              style: theme.textTheme.bodySmall?.copyWith(
                                height: 1.3,
                                color: theme.textTheme.bodyMedium?.color
                                    ?.withOpacity(0.7),
                              ),
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 32,
                          child: Row(
                            children: [
                              if (experience.isNotEmpty && experience != 'N/A')
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade50.withOpacity(
                                        0.5,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: Colors.green.shade200,
                                        width: 0.5,
                                      ),
                                    ),
                                    child: Text(
                                      experience,
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.green.shade700,
                                          ),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              SizedBox(
                                width:
                                    experience.isNotEmpty && experience != 'N/A'
                                    ? 6
                                    : 0,
                              ),
                              Container(
                                height: 32,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: theme.colorScheme.primary
                                          .withOpacity(0.2),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  "View",
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onPrimary,
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
