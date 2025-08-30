import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:facultypedia/components/courses/course_card.dart';
import 'package:facultypedia/components/custom_drawer.dart';
import 'package:facultypedia/screens/courses/course_details_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  List<dynamic> categories = [];

  @override
  void initState() {
    super.initState();
    loadCourses();
  }

  Future<void> loadCourses() async {
    final String response = await rootBundle.loadString('assets/data/courses.json');
    final data = await json.decode(response);
    setState(() {
      categories = data["categories"];
    });
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.bars, color: Colors.black87, size: 20),
          onPressed: () => scaffoldKey.currentState?.openDrawer(),
        ),
        title: Image.asset("assets/images/fp.png", height: 60),
        centerTitle: true,
      ),
      drawer: CustomDrawer(),
      body: categories.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: categories.map((category) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              category["title"],
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                }).toList(),
              ),
            ),
    );
  }
}
