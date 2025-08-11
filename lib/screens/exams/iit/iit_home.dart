import 'package:facultypedia/components/course_card.dart';
import 'package:facultypedia/components/custom_drawer.dart';
import 'package:facultypedia/components/educator_card.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TopEducatorsCarousel extends StatelessWidget {
  const TopEducatorsCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
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
        child: Container(
          color: Colors.grey.shade100, // Light background for section
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Top Educators",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
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

              const SizedBox(height: 10),

              // Carousel
              CarouselSlider(
                options: CarouselOptions(
                  height: 360,
                  enlargeCenterPage: true,
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Online Courses for IIT-JEE",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text("View More"),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 380,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    CourseCard(
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
                    ),
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
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
