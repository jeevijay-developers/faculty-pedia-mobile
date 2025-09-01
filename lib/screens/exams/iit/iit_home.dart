import 'dart:convert';
import 'package:facultypedia/components/testcomponents/test_series_detaild.dart'
    hide EducatorCard;
import 'package:facultypedia/screens/educators/educator_profile_page.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

// components
import 'package:facultypedia/components/courses/course_card.dart';
import 'package:facultypedia/components/educator/educator_card.dart';
import 'package:facultypedia/components/cards/livecard.dart';
import 'package:facultypedia/components/cards/test_series_card.dart';

// pages
import 'package:facultypedia/screens/courses/course_details_page.dart';

class IITHomePage extends StatefulWidget {
  const IITHomePage({super.key});

  @override
  State<IITHomePage> createState() => _IITHomePageState();
}

class _IITHomePageState extends State<IITHomePage> {
  List<dynamic> categories = [];

  @override
  void initState() {
    super.initState();
    loadCourses();
  }

  Future<void> loadCourses() async {
    final String response = await rootBundle.loadString(
      'assets/data/courses.json',
    );
    final data = await json.decode(response);

    // ✅ Filter only "JEE Advanced" & "JEE Mains"
    final filtered = (data["categories"] as List).where((cat) {
      final title = cat["title"].toString().toLowerCase();
      return title.contains("jee advanced") || title.contains("jee mains");
    }).toList();

    setState(() {
      categories = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("IIT Courses", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: categories.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔹 Top Educators Section
                  _buildSectionHeader("Top Educators", onViewMore: () {
                    
                  }),
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 360,
                      enlargeCenterPage: false,
                      enableInfiniteScroll: true,
                      viewportFraction: 0.7,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 4),
                    ),
                    items: [
                      EducatorCard(
                        imageUrl: "https://placehold.co/600x400.png",
                        name: "Dr. Ankur Gupta",
                        subject: "Chemistry",
                        education: "PhD, Chemistry",
                        experience: "12 years",
                        specialization: "Physical Chemistry",
                        onViewProfile: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EducatorProfilePage(
                                name: "Dr. Ankur Gupta",
                                subject: "Chemistry",
                                description: "Expert in Physical Chemistry",
                                education: "PhD, Chemistry",
                                experience: "12 years",
                                rating: 4.8,
                                reviews: 120,
                                followers: 500,
                                tag: "IIT-JEE",
                                imageUrl: "https://placehold.co/600x400.png",
                                youtubeUrl: "https://www.youtube.com/",
                                email: "ankur.gupta@example.com",
                                phone: "123-456-7890",
                                socialLinks: {
                                  "LinkedIn":
                                      "https://www.linkedin.com/in/ankur-gupta",
                                  "Twitter": "https://twitter.com/ankur_gupta",
                                },
                              ),
                            ),
                          );
                        },
                      ),
                      EducatorCard(
                        imageUrl: "https://placehold.co/600x400.png",
                        name: "Prof. Neha Sharma",
                        subject: "Mathematics",
                        education: "PhD, Mathematics",
                        experience: "15 years",
                        specialization: "Calculus & Algebra",
                        onViewProfile: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EducatorProfilePage(
                                name: "Prof. Neha Sharma",
                                subject: "Mathematics",
                                description: "Expert in Calculus & Algebra",
                                education: "PhD, Mathematics",
                                experience: "15 years",
                                rating: 4.9,
                                reviews: 150,
                                followers: 600,
                                tag: "IIT-JEE",
                                imageUrl: "https://placehold.co/600x400.png",
                                youtubeUrl: "https://www.youtube.com/",
                                email: "neha.sharma@example.com",
                                phone: "987-654-3210",
                                socialLinks: {
                                  "LinkedIn":
                                      "https://www.linkedin.com/in/neha-sharma",
                                  "Twitter": "https://twitter.com/neha_sharma",
                                },
                              ),
                            ),
                          );
                        },
                      ),
                      EducatorCard(
                        imageUrl: "https://placehold.co/600x400.png",
                        name: "Dr. Rajiv Mehta",
                        subject: "Physics",
                        education: "PhD, Physics",
                        experience: "10 years",
                        specialization: "Mechanics & Electrodynamics",
                        onViewProfile: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EducatorProfilePage(
                                name: "Dr. Rajiv Mehta",
                                subject: "Physics",
                                description:
                                    "Expert in Mechanics & Electrodynamics",
                                education: "PhD, Physics",
                                experience: "10 years",
                                rating: 4.7,
                                reviews: 100,
                                followers: 450,
                                tag: "IIT-JEE",
                                imageUrl: "https://placehold.co/600x400.png",
                                youtubeUrl: "https://www.youtube.com/",
                                email: "rajiv.mehta@example.com",
                                phone: "987-654-3210",
                                socialLinks: {
                                  "LinkedIn":
                                      "https://www.linkedin.com/in/rajiv-mehta",
                                  "Twitter": "https://twitter.com/rajiv_mehta",
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  // 🔹 Dynamic Course Categories (from JSON)
                  ...categories.map((category) {
                    return Column(
                      children: [
                        _buildSectionHeader(
                          category["title"],
                          onViewMore: () {},
                        ),
                        CarouselSlider(
                          options: CarouselOptions(
                            height: 400,
                            enlargeCenterPage: false,
                            enableInfiniteScroll: true,
                            viewportFraction: 0.7,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 4),
                          ),
                          items: (category["courses"] as List).map((course) {
                            return CourseCard(
                              title: course["title"],
                              educatorName: course["educatorName"],
                              description: course["description"],
                              durationText: course["durationText"],
                              price: course["price"],
                              oldPrice: course["oldPrice"],
                              imageUrl: course["imageUrl"],
                              onEnroll: () {},
                              onViewDetails: () {
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
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    );
                  }),

                  // 🔹 Live Courses Section
                  _buildSectionHeader(
                    "1 V 1 Live Course Classes",
                    onViewMore: () {},
                  ),
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 400,
                      enlargeCenterPage: false,
                      enableInfiniteScroll: true,
                      viewportFraction: 0.7,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 4),
                    ),
                    items: [
                      LiveCard(
                        imageUrl: 'https://placehold.co/600x400.png',
                        courseTitle: 'Physics Concepts Simplified',
                        instructorName: "Dr Rajiv Mehta",
                        qualification: "Ph.D., Physics",
                        subject: "Physics",
                        totalHours: 38,
                        fee: "14,500",
                        onEnroll: () {},
                        onViewDetails: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CourseDetailsPage(
                                title: 'Physics Concepts Simplified',
                                educatorName: "Dr Rajiv Mehta",
                                description:
                                    "A deep dive into the fundamental concepts of Physics.",
                                durationText: "38 hours",
                                price: 14500,
                                oldPrice: 16000,
                                imageUrl: 'https://placehold.co/600x400.png',
                              ),
                            ),
                          );
                        },
                      ),
                      LiveCard(
                        imageUrl: 'https://placehold.co/600x400.png',
                        courseTitle: 'Advanced Chemistry',
                        instructorName: "Dr Ankur Gupta",
                        qualification: "Ph.D., Chemistry",
                        subject: "Chemistry",
                        totalHours: 40,
                        fee: "15,000",
                        onEnroll: () {},
                        onViewDetails: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CourseDetailsPage(
                                title: 'Advanced Chemistry',
                                educatorName: "Dr Ankur Gupta",
                                description:
                                    "An in-depth exploration of chemical principles.",
                                durationText: "40 hours",
                                price: 15000,
                                oldPrice: 16000,
                                imageUrl: 'https://placehold.co/600x400.png',
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  // 🔹 Pay Per Hour Classes
                  _buildSectionHeader(
                    "1 V 1 Live Pay Per Hour Class",
                    onViewMore: () {},
                  ),
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 400,
                      enlargeCenterPage: false,
                      enableInfiniteScroll: true,
                      viewportFraction: 0.7,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 4),
                    ),
                    items: [
                      LiveCard(
                        imageUrl: 'https://placehold.co/600x400.png',
                        courseTitle: 'Math Problem Solving',
                        instructorName: "Prof. Neha Sharma",
                        qualification: "Ph.D., Mathematics",
                        subject: "Mathematics",
                        totalHours: 20,
                        fee: "800/hr",
                        onEnroll: () {},
                        onViewDetails: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CourseDetailsPage(
                                title: 'Math Problem Solving',
                                educatorName: "Prof. Neha Sharma",
                                description:
                                    "Focused sessions on solving complex math problems.",
                                durationText: "20 hours",
                                price: 16000,
                                oldPrice: 18000,
                                imageUrl: 'https://placehold.co/600x400.png',
                              ),
                            ),
                          );
                        },
                      ),
                      LiveCard(
                        imageUrl: 'https://placehold.co/600x400.png',
                        courseTitle: 'Physics Doubt Clearing',
                        instructorName: "Dr Rajiv Mehta",
                        qualification: "Ph.D., Physics",
                        subject: "Physics",
                        totalHours: 25,
                        fee: "1000/hr",
                        onEnroll: () {},
                        onViewDetails: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CourseDetailsPage(
                                title: 'Physics Doubt Clearing',
                                educatorName: "Dr Rajiv Mehta",
                                description:
                                    "Personalized sessions to clear physics doubts.",
                                durationText: "25 hours",
                                price: 25000,
                                oldPrice: 27000,
                                imageUrl: 'https://placehold.co/600x400.png',
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  // 🔹 Test Series Section
                  _buildSectionHeader("Online Test Series", onViewMore: () {}),
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 400,
                      enlargeCenterPage: false,
                      enableInfiniteScroll: true,
                      viewportFraction: 0.7,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 4),
                    ),
                    items: [
                      TestSeriesCard(
                        imageUrl: 'https://placehold.co/600x400.png',
                        courseTitle: 'IIT-JEE Physics Test Series',
                        instructorName: "Dr Rajiv Mehta",
                        qualification: "Ph.D., Physics",
                        subject: "Physics",
                        totalTests: 18,
                        fee: "14,500",
                        onEnroll: () {},
                        onViewDetails: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TestDetailsPage(
                                title: 'IIT-JEE Physics Test Series',
                                educatorName: "Dr Rajiv Mehta",
                                description:
                                    "In-depth mock tests for IIT-JEE Physics.",
                                totalTest: "20 tests",
                                price: "13000",
                                // oldPrice: 14000,
                                // imageUrl: 'https://placehold.co/600x400.png',
                                syllabus: 'SYLLABUS',
                                syllabusItem: [
                                  "Mechanics and Motion",
                                  "Thermodynamics",
                                  "Electromagnetism",
                                  "Optics and Waves",
                                  "Modern Physics Concept",
                                ],
                                specialization: 'IIT-JEE',
                                tag: 'Physics',
                              ),
                            ),
                          );
                        },
                      ),
                      TestSeriesCard(
                        imageUrl: 'https://placehold.co/600x400.png',
                        courseTitle: 'Chemistry Mock Tests',
                        instructorName: "Dr Ankur Gupta",
                        qualification: "Ph.D., Chemistry",
                        subject: "Chemistry",
                        totalTests: 20,
                        fee: "13,000",
                        onEnroll: () {},
                        onViewDetails: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TestDetailsPage(
                                title: 'Chemistry Mock Tests',
                                educatorName: "Dr Ankur Gupta",
                                description:
                                    "In-depth mock tests for IIT-JEE Chemistry.",
                                totalTest: "20 tests",
                                price: "13000",
                                // oldPrice: 14000,
                                // imageUrl: 'https://placehold.co/600x400.png',
                                syllabus: '',
                                syllabusItem: [],
                                specialization: 'IIT-JEE',
                                tag: 'Chemistry',
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  // 🔹 Helper method for headers
  Widget _buildSectionHeader(String title, {required VoidCallback onViewMore}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          TextButton(onPressed: onViewMore, child: const Text("View More")),
        ],
      ),
    );
  }
}
