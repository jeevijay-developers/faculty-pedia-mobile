import 'dart:convert';
import 'package:facultypedia/components/courses/course_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:facultypedia/screens/courses/course_details_page.dart';

class CBSEHome extends StatefulWidget {
  const CBSEHome({super.key});

  @override
  State<CBSEHome> createState() => _CBSEHomeState();
}

class _CBSEHomeState extends State<CBSEHome> {
  List<dynamic> allCourses = [];
  List<dynamic> filteredCourses = [];
  String? selectedClass;

  @override
  void initState() {
    super.initState();
    loadCourses();
  }

  Future<void> loadCourses() async {
    final String response = await rootBundle.loadString(
      'assets/data/courses.json',
    );
    final data = json.decode(response);

    // 🔑 Pick only the CBSE category from JSON
    final cbseCategory = (data['categories'] as List).firstWhere(
      (cat) => cat['title'] == "Courses for CBSE",
      orElse: () => null,
    );

    if (cbseCategory != null) {
      setState(() {
        allCourses = cbseCategory['courses'];
        filteredCourses = allCourses; // default: show all
      });
    }
  }

  void filterByClass(String? className) {
    setState(() {
      selectedClass = className;
      if (className == null || className == "All") {
        filteredCourses = allCourses;
      } else {
        filteredCourses = allCourses.where((course) {
          return course['title'].toString().contains(className);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("CBSE Courses")),
      body: Column(
        children: [
          // 🔽 Dropdown for class selection
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Select Class",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              value: selectedClass,
              items: [
                const DropdownMenuItem(
                  value: "All",
                  child: Text("All Classes"),
                ),
                const DropdownMenuItem(
                  value: "Class 9",
                  child: Text("Class 6"),
                ),
                const DropdownMenuItem(
                  value: "Class 9",
                  child: Text("Class 7"),
                ),
                const DropdownMenuItem(
                  value: "Class 9",
                  child: Text("Class 8"),
                ),
                const DropdownMenuItem(
                  value: "Class 9",
                  child: Text("Class 9"),
                ),
                const DropdownMenuItem(
                  value: "Class 10",
                  child: Text("Class 10"),
                ),
                const DropdownMenuItem(
                  value: "Class 11",
                  child: Text("Class 11"),
                ),
                const DropdownMenuItem(
                  value: "Class 12",
                  child: Text("Class 12"),
                ),
              ],
              onChanged: filterByClass,
            ),
          ),

          // 🔽 Courses List
          Expanded(
            child: filteredCourses.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: filteredCourses.length,
                    itemBuilder: (context, index) {
                      final course = filteredCourses[index];
                      return CourseCard(
                        title: course['title'],
                        educatorName: course['educatorName'],
                        description: course['description'],
                        durationText: course['durationText'],
                        price: course['price'],
                        oldPrice: course['oldPrice'],
                        imageUrl: course['imageUrl'],
                        onEnroll: () {
                          // TODO: add your enroll logic
                        },
                        onViewDetails: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CourseDetailsPage(
                                title: course['title'],
                                educatorName: course['educatorName'],
                                description: course['description'],
                                durationText: course['durationText'],
                                price: course['price'],
                                oldPrice: course['oldPrice'],
                                imageUrl: course['imageUrl'],
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
