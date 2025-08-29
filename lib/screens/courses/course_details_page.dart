import 'package:facultypedia/components/course_class_card.dart';
import 'package:facultypedia/components/course_overview.dart';
import 'package:facultypedia/components/test_series_card.dart';
import 'package:flutter/material.dart';

class CourseDetailsPage extends StatelessWidget {
  final String title;
  final String educatorName;
  final String description;
  final String durationText;
  final double price;
  final double oldPrice;
  final String imageUrl;

  const CourseDetailsPage({
    super.key,
    required this.title,
    required this.educatorName,
    required this.description,
    required this.durationText,
    required this.price,
    required this.oldPrice,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(title: Text(title), centerTitle: true),

        // ✅ Enroll Card fixed at bottom
        bottomNavigationBar: _bottomEnrollBar(context),

        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _topCard(context),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverTabBarDelegate(
                const TabBar(
                  labelColor: Colors.blue,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.blue,
                  tabs: [
                    Tab(text: "Overview"),
                    Tab(text: "Classes (2)"),
                    Tab(text: "Tests (1)"),
                  ],
                ),
              ),
            ),
          ],
          body: TabBarView(
            children: [
              // Overview Tab
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [CourseOverview()],
                ),
              ),

              // Classes Tab
              // Inside TabBarView → Classes Tab
              ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  CourseClassCard(
                    title: "Laws of Motion",
                    topic: "Mechanics",
                    date: DateTime(2025, 9, 1),
                    timeRange: "9:00 AM - 11:00 AM",
                    description: "Newton's laws and their applications",
                    subject: "Physics",
                    durationMinutes: 120,
                    onJoinClass: () {
                      // TODO: Handle Join Class
                      print("Joining Laws of Motion class");
                    },
                    onDownloadPPT: () {
                      // TODO: Handle PPT download
                      print("Downloading Laws of Motion PPT");
                    },
                    onDownloadPDF: () {
                      // TODO: Handle PDF download
                      print("Downloading Laws of Motion PDF");
                    },
                  ),
                  CourseClassCard(
                    title: "Work, Energy and Power",
                    topic: "Work-Energy",
                    date: DateTime(2025, 9, 8),
                    timeRange: "9:00 AM - 11:00 AM",
                    description: "Energy conservation and power calculations",
                    subject: "Physics",
                    durationMinutes: 120,
                    onJoinClass: () {
                      print("Joining Work, Energy and Power class");
                    },
                    onDownloadPPT: () {
                      print("Downloading Work, Energy and Power PPT");
                    },
                    onDownloadPDF: () {
                      print("Downloading Work, Energy and Power PDF");
                    },
                  ),
                ],
              ),

              // Tests Tab
              ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text(
                    "Course Tests",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Practice tests and assessments for this course",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  TestSeriesCard(
                    imageUrl: "https://placehold.co/600x400.png",
                    courseTitle: "Mechanics Test",
                    instructorName: "Prof. Anita Singh",
                    qualification: "Course Test",
                    subject: "Physics",
                    totalTests: 1,
                    fee: "₹0",
                    onEnroll: () {},
                    onViewDetails: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============ Bottom Enroll Bar ============
  Widget _bottomEnrollBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "₹${price.toStringAsFixed(0)}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              Text(
                "₹${oldPrice.toStringAsFixed(0)}",
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {},
            child: const Text(
              "Enroll Now",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============ Top Course Card ============
  Widget _topCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Placeholder
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[300],
            ),
            alignment: Alignment.center,
            child: const Text("600 x 400"),
          ),
          const SizedBox(height: 12),

          // Tags
          Wrap(
            spacing: 8,
            children: [_tag("IIT-JEE"), _tag("Class 11"), _tag("One to All")],
          ),
          const SizedBox(height: 12),

          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(description, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 4),
          Text.rich(
            TextSpan(
              text: "Instructor: ",
              style: const TextStyle(fontWeight: FontWeight.w500),
              children: [
                TextSpan(
                  text: educatorName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              _CourseStat(title: "Duration", value: "20 weeks"),
              _CourseStat(title: "Classes", value: "2"),
              _CourseStat(title: "Per Class", value: "2h"),
              _CourseStat(title: "Seats", value: "60"),
            ],
          ),
          const SizedBox(height: 16),

          // Info Cards
          Row(
            children: [
              Expanded(
                child: _infoCard(
                  color: Color(0xFFE9FBE7),
                  icon: Icons.currency_rupee,
                  title: "Course Fee",
                  value: "₹6,999",
                  subtitle: "₹8999",
                  valueColor: Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _infoCard(
                  color: Color(0xFFE8F1FE),
                  icon: Icons.calendar_today,
                  title: "Timeline",
                  value: "Start: Sep 1, 2025",
                  subtitle: "End: Jan 20, 2026",
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _infoCard(
                  color: Color(0xFFF3E8FE),
                  icon: Icons.people,
                  title: "Enrollment",
                  value: "0/60",
                  subtitle: "Students",
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _infoCard(
                  color: Color(0xFFFFF3E0),
                  icon: Icons.menu_book,
                  title: "Subject",
                  value: "Physics",
                  subtitle: "IIT-JEE",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ======= Helpers =======
  static Widget _tag(String text) {
    return Chip(label: Text(text), backgroundColor: Colors.blue.shade50);
  }

  static Widget _infoCard({
    required Color color,
    required IconData icon,
    required String title,
    required String value,
    String? subtitle,
    Color? valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: Colors.black87),
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(color: Colors.black54)),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: valueColor ?? Colors.black,
            ),
          ),
          if (subtitle != null)
            Text(subtitle, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

// Custom Sliver Delegate for TabBar
class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  _SliverTabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: Colors.white, child: tabBar);
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) => false;
}

// Course Stat Widget
class _CourseStat extends StatelessWidget {
  final String title;
  final String value;
  const _CourseStat({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
