import 'package:carousel_slider/carousel_slider.dart';
import 'package:facultypedia/components/course_card.dart';
import 'package:facultypedia/components/custom_drawer.dart';
import 'package:facultypedia/components/educator_card.dart';
import 'package:facultypedia/components/livecard.dart';
import 'package:facultypedia/components/test_series_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CBSEHome extends StatefulWidget {
  const CBSEHome({super.key});

  @override
  State<CBSEHome> createState() => _CBSEHomeState();
}

class _CBSEHomeState extends State<CBSEHome> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final List<String> list = [
    "CBSE Class 6",
    "CBSE Class 7",
    "CBSE Class 8",
    "CBSE Class 9",
    "CBSE Class 10",
    "CBSE Class 11",
    "CBSE Class 12",
  ];

  String dropdownValue = "CBSE Class 6";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB), // Softer background
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // cleaner look
        leading: IconButton(
          icon: const FaIcon(
            FontAwesomeIcons.bars,
            color: Colors.black87,
            size: 20,
          ),
          onPressed: () => scaffoldKey.currentState?.openDrawer(),
        ),
        title: Image.asset("assets/images/fp.png", height: 32),
        centerTitle: true,
      ),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 8),

            /// Title
            Text(
              "CBSE Courses",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 28,
                color: Colors.grey.shade900,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 20),

            /// Minimal dropdown
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: dropdownValue,
                    isExpanded: true,
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.black54,
                    ),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        dropdownValue = value!;
                      });
                    },
                    items: list
                        .map(
                          (value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Top Educators",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blueAccent,
                    ),
                    onPressed: () {},
                    child: const Row(
                      children: [
                        Text("View More", style: TextStyle(fontSize: 14)),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward_ios, size: 14),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
                  onViewProfile: () {},
                ),
                EducatorCard(
                  imageUrl: "https://placehold.co/600x400.png",
                  name: "Prof. Neha Sharma",
                  subject: "Mathematics",
                  education: "PhD, Mathematics",
                  experience: "15 years",
                  specialization: "Calculus & Algebra",
                  onViewProfile: () {},
                ),
                EducatorCard(
                  imageUrl: "https://placehold.co/600x400.png",
                  name: "Dr. Rajiv Mehta",
                  subject: "Physics",
                  education: "PhD, Physics",
                  experience: "10 years",
                  specialization: "Mechanics & Electrodynamics",
                  onViewProfile: () {},
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Online Courses for $dropdownValue",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
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
                CourseCard(
                  title: "English for Competitive Exams",
                  educatorName: "Ms. Priya Mehta",
                  description:
                      "Complete English preparation for all competitive exams with grammar and comprehension.",
                  durationText: "4 months starting from 10 Sep 2025",
                  price: 4999,
                  oldPrice: 6999,
                  onEnroll: () {},
                  onViewDetails: () {},
                  imageUrl: 'https://placehold.co/600x400.png',
                ),
                CourseCard(
                  title: "Chemistry Complete Package",
                  educatorName: "Dr. Vikram Patel",
                  description:
                      "Comprehensive chemistry course covering organic, inorganic, and physical chemistry.",
                  durationText: "7 months starting from 20 Aug 2025",
                  price: 7499,
                  oldPrice: 9499,
                  onEnroll: () {},
                  onViewDetails: () {},
                  imageUrl: 'https://placehold.co/600x400.png',
                ),
                CourseCard(
                  imageUrl: "https://placehold.co/600x400.png",
                  title: "Physics for Engineering",
                  educatorName: "Prof. Anita Singh",
                  description:
                      "Advanced physics concepts for engineering entrance exams with practical applications.",
                  durationText: "5 months starting from 1 Sep 2025",
                  price: 6999,
                  oldPrice: 9999,
                  onEnroll: () {},
                  onViewDetails: () {},
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "1 V 1 Live Course Classes",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  TextButton(onPressed: () {}, child: const Text("View More")),
                ],
              ),
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
                  onEnroll: () {},
                  qualification: "Ph.D., Physics",
                  subject: "Physics",
                  totalHours: 38,
                  fee: "14,500",
                  onViewDetails: () {},
                ),
                LiveCard(
                  imageUrl: 'https://placehold.co/600x400.png',
                  courseTitle: 'Physics Concepts Simplified',
                  instructorName: "Dr Rajiv Mehta",
                  onEnroll: () {},
                  qualification: "Ph.D., Physics",
                  subject: "Physics",
                  totalHours: 38,
                  fee: "14,500",
                  onViewDetails: () {},
                ),
                LiveCard(
                  imageUrl: 'https://placehold.co/600x400.png',
                  courseTitle: 'Physics Concepts Simplified',
                  instructorName: "Dr Rajiv Mehta",
                  onEnroll: () {},
                  qualification: "Ph.D., Physics",
                  subject: "Physics",
                  totalHours: 38,
                  fee: "14,500",
                  onViewDetails: () {},
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "1 V 1 Live Pay Per Hour Class",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  TextButton(onPressed: () {}, child: const Text("View More")),
                ],
              ),
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
                  onEnroll: () {},
                  qualification: "Ph.D., Physics",
                  subject: "Physics",
                  totalHours: 38,
                  fee: "14,500",
                  onViewDetails: () {},
                ),
                LiveCard(
                  imageUrl: 'https://placehold.co/600x400.png',
                  courseTitle: 'Physics Concepts Simplified',
                  instructorName: "Dr Rajiv Mehta",
                  onEnroll: () {},
                  qualification: "Ph.D., Physics",
                  subject: "Physics",
                  totalHours: 38,
                  fee: "14,500",
                  onViewDetails: () {},
                ),
                LiveCard(
                  imageUrl: 'https://placehold.co/600x400.png',
                  courseTitle: 'Physics Concepts Simplified',
                  instructorName: "Dr Rajiv Mehta",
                  onEnroll: () {},
                  qualification: "Ph.D., Physics",
                  subject: "Physics",
                  totalHours: 38,
                  fee: "14,500",
                  onViewDetails: () {},
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Online Test Series",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  TextButton(onPressed: () {}, child: const Text("View More")),
                ],
              ),
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
                TestSeriesCard(
                  imageUrl: 'https://placehold.co/600x400.png',
                  courseTitle: 'Physics Concepts Simplified',
                  instructorName: "Dr Rajiv Mehta",
                  onEnroll: () {},
                  qualification: "Ph.D., Physics",
                  subject: "Physics",
                  totalTests: 18,
                  fee: "14,500",
                  onViewDetails: () {},
                ),
                TestSeriesCard(
                  imageUrl: 'https://placehold.co/600x400.png',
                  courseTitle: 'Physics Concepts Simplified',
                  instructorName: "Dr Rajiv Mehta",
                  onEnroll: () {},
                  qualification: "Ph.D., Physics",
                  subject: "Physics",
                  totalTests: 18,
                  fee: "14,500",
                  onViewDetails: () {},
                ),
                TestSeriesCard(
                  imageUrl: 'https://placehold.co/600x400.png',
                  courseTitle: 'Physics Concepts Simplified',
                  instructorName: "Dr Rajiv Mehta",
                  onEnroll: () {},
                  qualification: "Ph.D., Physics",
                  subject: "Physics",
                  totalTests: 18,
                  fee: "14,500",
                  onViewDetails: () {},
                ),
              ],
            ),

            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }
}
