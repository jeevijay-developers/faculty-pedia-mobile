import 'package:flutter/material.dart';

class TestDetailsPage extends StatelessWidget {
  final String title;
  final String educatorName;
  final String description;
  final String totalTest;
  final String syllabus;
  final String price;
  final String specialization;
  final String tag;
  final List<String> syllabusItem;

  const TestDetailsPage({
    super.key,
    required this.title,
    required this.educatorName,
    required this.description,
    required this.totalTest,
    required this.syllabus,
    required this.price,
    required this.syllabusItem,
    required this.specialization,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(title: Text(title), centerTitle: true),

        // ✅ Fixed bottom enroll bar
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
                    Tab(text: "Syllabus"),
                    Tab(text: "Info"),
                  ],
                ),
              ),
            ),
          ],
          body: TabBarView(
            children: [
              // ===== Overview Tab =====
              description.trim().isNotEmpty
                  ? SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        description,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                    )
                  : const Center(child: Text("No overview available")),

              // ===== Syllabus Tab =====
              syllabusItem.isNotEmpty
                  ? ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: syllabusItem.length,
                      itemBuilder: (context, index) {
                        return _syllabusTile(syllabusItem[index]);
                      },
                    )
                  : const Center(child: Text("No syllabus available")),

              // ===== Info Tab =====
              (totalTest.isNotEmpty || specialization.isNotEmpty)
                  ? ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        if (totalTest.isNotEmpty)
                          _infoCard(
                            color: const Color(0xFFE9FBE7),
                            icon: Icons.assignment,
                            title: "Total Tests",
                            value: totalTest,
                          ),
                        if (specialization.isNotEmpty)
                          const SizedBox(height: 12),
                        if (specialization.isNotEmpty)
                          _infoCard(
                            color: const Color(0xFFE8F1FE),
                            icon: Icons.category,
                            title: "Specialization",
                            value: specialization,
                          ),
                        const SizedBox(height: 12),
                        _infoCard(
                          color: const Color(0xFFFFF3E0),
                          icon: Icons.calendar_today,
                          title: "Validity",
                          value: "12 months",
                        ),
                      ],
                    )
                  : const Center(child: Text("No info available")),
            ],
          ),
        ),
      ),
    );
  }

  // ================= Top Card =================
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
          // Banner placeholder
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
            children: [_tag("Test Series"), _tag(tag), _tag("IIT-JEE")],
          ),
          const SizedBox(height: 12),

          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            "Instructor: $educatorName",
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // Stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              _TestStat(title: "Tests", value: "22"),
              _TestStat(title: "Duration", value: "12 mo"),
              _TestStat(title: "Access", value: "Unlimited"),
            ],
          ),
        ],
      ),
    );
  }

  // ================= Bottom Enroll Bar =================
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
          Text(
            "₹$price",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
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

  // ================= Helper Widgets =================
  static Widget _tag(String text) {
    return Chip(label: Text(text), backgroundColor: Colors.blue.shade50);
  }

  static Widget _syllabusTile(String item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 20, color: Colors.blueAccent),
          const SizedBox(width: 10),
          Expanded(child: Text(item, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }

  static Widget _infoCard({
    required Color color,
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 22, color: Colors.black87),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.black54)),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ========== Custom Sliver Delegate ==========
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

// ========== Test Stat Widget ==========
class _TestStat extends StatelessWidget {
  final String title;
  final String value;
  const _TestStat({required this.title, required this.value});

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
