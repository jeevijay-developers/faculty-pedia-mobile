import 'package:facultypedia/components/custom_drawer.dart';
import 'package:facultypedia/components/educators_card.dart';
import 'package:facultypedia/screens/educators/educator_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EducatorsPage extends StatefulWidget {
  const EducatorsPage({super.key});

  @override
  State<EducatorsPage> createState() => _EducatorsPageState();
}

class _EducatorsPageState extends State<EducatorsPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  String selectedCategory = "All"; // 👈 track selected category

  final List<String> categories = [
    "All",
    "Math",
    "Physics",
    "Chemistry",
    "Biology",
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
  Widget build(BuildContext context) {
    // 🔹 Filter educators based on selected category
    final filteredEducators = selectedCategory == "All"
        ? educators
        : educators.where((e) => e["subject"] == selectedCategory).toList();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const FaIcon(
            FontAwesomeIcons.bars,
            color: Colors.black87,
            size: 20,
          ),
          onPressed: () => scaffoldKey.currentState?.openDrawer(),
        ),
        title: Image.asset("assets/images/fp.png", height: 50),
        centerTitle: true,
      ),
      drawer: CustomDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Center(
            child: Text(
              "Our Expert Educators",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),

          // 🔹 Category Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: categories.map((category) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ChoiceChip(
                      checkmarkColor: Colors.white,
                      label: Text(
                        category,
                        style: TextStyle(
                          fontWeight: selectedCategory == category
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: selectedCategory == category
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      selected: selectedCategory == category,
                      selectedColor: Colors.blue.shade700,
                      backgroundColor: Colors.grey.shade200,
                      onSelected: (bool selected) {
                        setState(() {
                          selectedCategory = category;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // 🔹 Educators list (filtered ✅)
          Expanded(
            child: filteredEducators.isEmpty
                ? const Center(child: Text("No educators found"))
                : ListView.builder(
                    itemCount: filteredEducators.length,
                    itemBuilder: (context, index) {
                      final e = filteredEducators[index];
                      return EducatorsCard(
                        name: e["name"],
                        subject: e["subject"],
                        description: e["description"],
                        education: e["education"],
                        experience: e["experience"],
                        rating: e["rating"],
                        reviews: e["reviews"],
                        followers: e["followers"],
                        tag: e["tag"],
                        imageUrl: e["imageUrl"],
                        onProfileTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EducatorProfilePage(
                                name: e["name"],
                                subject: e["subject"],
                                description: e["description"],
                                education: e["education"],
                                experience: e["experience"],
                                rating: e["rating"],
                                reviews: e["reviews"],
                                followers: e["followers"],
                                tag: e["tag"],
                                imageUrl: e["imageUrl"],
                                youtubeUrl: e['youtubeUrl'],
                                email: e['email'],
                                phone: e['phone'],
                                socialLinks: e['socialLinks'],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
