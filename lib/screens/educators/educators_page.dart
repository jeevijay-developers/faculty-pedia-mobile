import 'package:facultypedia/components/custom_drawer.dart';
import 'package:facultypedia/screens/educators/educator_profile_page.dart';
import 'package:flutter/material.dart';

const Color kPrimaryColor = Color(0xFF4A90E2);

class EducatorsPage extends StatefulWidget {
  final String? preselectedCategory;

  const EducatorsPage({super.key, this.preselectedCategory});

  @override
  State<EducatorsPage> createState() => _EducatorsPageState();
}

class _EducatorsPageState extends State<EducatorsPage>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  String selectedCategory = "All"; // 👈 track selected category
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<String> categories = [
    "All",
    "Math",
    "Physics",
    "Chemistry",
    "Biology",
    "IIT",
    "NEET",
    "CBSE",
  ];

  // 👩‍🏫 Sample educators data
  final List<Map<String, dynamic>> educators = [
    {
      "name": "Dr. Suresh Nair",
      "subject": "Physics",
      "description":
          "Physics educator specializing in mechanics and thermodynamics for NEET students.",
      "education": "M.SC PHYSICS",
      "experience": "9+ years",
      "rating": 4.5,
      "reviews": 88,
      "followers": 2,
      "tag": "NEET",
      "imageUrl": "https://placehold.co/150.png",
      "youtubeUrl": "https://youtu.be/jCVjudmnByk?si=32HT74QtsWX9KKPE ",
      "email": "test@test.com",
      "phone": "+91 1234567899",
      "socialLinks": {},
    },
    {
      "name": "Prof. Meera Sharma",
      "subject": "Math",
      "description": "Expert in algebra, calculus, and IIT-JEE coaching.",
      "education": "M.SC MATHEMATICS",
      "experience": "12+ years",
      "rating": 4.8,
      "reviews": 120,
      "followers": 15,
      "tag": "JEE",
      "imageUrl": "https://placehold.co/150.png",
      "youtubeUrl": "https://youtu.be/jCVjudmnByk?si=32HT74QtsWX9KKPE ",
      "email": "test@test.com",
      "phone": "+91 1234567899",
      "socialLinks": {},
    },
    {
      "name": "Dr. Anita Verma",
      "subject": "Chemistry",
      "description":
          "Specialist in organic and inorganic chemistry for JEE/NEET.",
      "education": "PhD Chemistry",
      "experience": "10+ years",
      "rating": 4.6,
      "reviews": 90,
      "followers": 8,
      "tag": "NEET",
      "imageUrl": "https://placehold.co/150.png",
      "youtubeUrl": "https://youtu.be/jCVjudmnByk?si=32HT74QtsWX9KKPE ",
      "email": "test@test.com",
      "phone": "+91 1234567899",
      "socialLinks": {},
    },
    {
      "name": "Dr. Ankit Verma",
      "subject": "Biology",
      "description": "Specialist in Biology for NEET.",
      "education": "PhD Biology",
      "experience": "10+ years",
      "rating": 4.6,
      "reviews": 90,
      "followers": 8,
      "tag": "NEET",
      "imageUrl": "https://placehold.co/150.png",
      "youtubeUrl": "https://youtu.be/jCVjudmnByk?si=32HT74QtsWX9KKPE ",
      "email": "test@test.com",
      "phone": "+91 1234567899",
      "socialLinks": {},
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
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
    if (widget.preselectedCategory != null &&
        categories.contains(widget.preselectedCategory)) {
      selectedCategory = widget.preselectedCategory!;
    }
  }

  @override
  Widget build(BuildContext context) {
    // 🔹 Filter educators based on selected category and search query
    final filteredEducators = educators.where((e) {
      bool categoryMatch =
          selectedCategory == "All" || e["subject"] == selectedCategory;
      bool searchMatch =
          _searchQuery.isEmpty ||
          e["name"].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          e["subject"].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          e["university"].toLowerCase().contains(_searchQuery.toLowerCase());
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
                  style: const TextStyle(color: Colors.black87, fontSize: 16),
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
      drawer: widget.preselectedCategory != null ? null : const CustomDrawer(),
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
                          },
                          borderRadius: BorderRadius.circular(25),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected ? kPrimaryColor : Colors.white,
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
              "${filteredEducators.length} Expert${filteredEducators.length != 1 ? 's' : ''} Available",
              selectedCategory == "All"
                  ? "Discover all our professional educators"
                  : "Specialists in $selectedCategory",
              filteredEducators.isEmpty
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
                              childAspectRatio: 0.75,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                        itemCount: filteredEducators.length,
                        itemBuilder: (context, index) {
                          final educator = filteredEducators[index];
                          return _buildModernEducatorCard(
                            educator["name"],
                            educator["subject"],
                            educator["education"],
                            educator["experience"],
                            educator["description"],
                            educator["imageUrl"],
                            educator["rating"].toDouble(),
                            educator["reviews"],
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EducatorProfilePage(
                                    name: educator["name"],
                                    subject: educator["subject"],
                                    description: educator["description"],
                                    education: educator["education"],
                                    experience: educator["experience"],
                                    rating: educator["rating"],
                                    reviews: educator["reviews"],
                                    followers: educator["followers"],
                                    tag: educator["tag"],
                                    imageUrl: educator["imageUrl"],
                                    youtubeUrl: educator['youtubeUrl'],
                                    email: educator['email'],
                                    phone: educator['phone'],
                                    socialLinks: educator['socialLinks'],
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
              height: 120,
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
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 14,
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
                        fontSize: 10,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          experience,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: kPrimaryColor,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "View Profile",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
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
