import 'package:carousel_slider/carousel_slider.dart';
import 'package:facultypedia/components/course_card.dart';
import 'package:facultypedia/components/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const FaIcon(
            FontAwesomeIcons.bars,
            color: Colors.black87,
            size: 20,
          ),
          onPressed: () {
            scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: Image.asset("assets/images/fp.png", height: 60),
        centerTitle: true,
      ),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Courses for JEE Mains",
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
                    "Courses for NEET",
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
                    "Courses for JEE-Advance",
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
                    "Competitive Courses",
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
          ],
        ),
      ),
    );
  }
}
