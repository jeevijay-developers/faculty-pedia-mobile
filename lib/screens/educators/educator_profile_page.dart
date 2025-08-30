import 'package:facultypedia/components/courses/course_card.dart';
import 'package:facultypedia/components/cards/test_series_card.dart';
import 'package:facultypedia/screens/courses/course_details_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// Import your CourseCard file here
// import 'course_card.dart';

class EducatorProfilePage extends StatefulWidget {
  final String name;
  final String subject;
  final String description;
  final String education;
  final String experience;
  final double rating;
  final int reviews;
  final int followers;
  final String tag;
  final String imageUrl;
  final String youtubeUrl;
  final String email;
  final String phone;
  final Map<dynamic, dynamic> socialLinks;

  const EducatorProfilePage({
    super.key,
    required this.name,
    required this.subject,
    required this.description,
    required this.education,
    required this.experience,
    required this.rating,
    required this.reviews,
    required this.followers,
    required this.tag,
    required this.imageUrl,
    required this.youtubeUrl,
    required this.email,
    required this.phone,
    required this.socialLinks,
  });

  @override
  State<EducatorProfilePage> createState() => _EducatorProfilePageState();
}

class _EducatorProfilePageState extends State<EducatorProfilePage> {
  YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(widget.youtubeUrl);
    if (videoId != null) {
      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: Text(widget.name, style: const TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// CARD 1 - Profile
            _buildProfileCard(),

            const SizedBox(height: 20),

            /// CARD 2 - Available Courses
            _buildCoursesSection(),

            const SizedBox(height: 20),

            /// CARD 3 - Test Series
            _buildTestSeriesSection(),

            const SizedBox(height: 20),

            /// CARD 4 - About
            _buildAboutCard(),
          ],
        ),
      ),
    );
  }

  /// ---------------- PROFILE CARD ----------------
  Widget _buildProfileCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Top section
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundImage: NetworkImage(widget.imageUrl),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Education: ${widget.education}",
                        style: const TextStyle(color: Colors.black87),
                      ),
                      Text(
                        "Experience: ${widget.experience}",
                        style: const TextStyle(color: Colors.black87),
                      ),
                      const SizedBox(height: 6),
                      Chip(
                        label: Text(widget.tag),
                        backgroundColor: Colors.blue.shade50,
                        labelStyle: const TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Follow",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// Trial Video
            if (_controller != null)
              YoutubePlayerBuilder(
                player: YoutubePlayer(
                  controller: _controller!,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: Colors.red,
                ),
                builder: (context, player) => Column(children: [player]),
              ),

            const SizedBox(height: 16),

            /// Contact Info
            Row(
              children: [
                const Icon(Icons.email, size: 18, color: Colors.blue),
                const SizedBox(width: 6),
                Text(widget.email),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.phone, size: 18, color: Colors.green),
                const SizedBox(width: 6),
                Text(widget.phone),
              ],
            ),

            const SizedBox(height: 16),

            /// Rating
            Row(
              children: [
                const Icon(Icons.star, color: Colors.orange),
                Text(
                  " ${widget.rating} ",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text("(${widget.reviews} reviews)"),
              ],
            ),

            const SizedBox(height: 12),

            /// Social Media Links
            Row(
              children: [
                if (widget.socialLinks.containsKey("twitter"))
                  IconButton(
                    icon: const Icon(
                      FontAwesomeIcons.twitter,
                      color: Colors.blue,
                    ),
                    onPressed: () {},
                  ),
                if (widget.socialLinks.containsKey("linkedin"))
                  IconButton(
                    icon: const Icon(
                      FontAwesomeIcons.linkedin,
                      color: Colors.blueAccent,
                    ),
                    onPressed: () {},
                  ),
                if (widget.socialLinks.containsKey("instagram"))
                  IconButton(
                    icon: const Icon(
                      FontAwesomeIcons.instagram,
                      color: Colors.purple,
                    ),
                    onPressed: () {},
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// ---------------- COURSES SECTION ----------------
  Widget _buildCoursesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Available Courses",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              CourseCard(
                title: "Complete Physics Course",
                educatorName: widget.name,
                description: "A comprehensive physics course for JEE/NEET.",
                durationText: "6 Months",
                price: 2999,
                oldPrice: 4999,
                onEnroll: () {},
                onViewDetails: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CourseDetailsPage(
                        title: "Complete Physics Course",
                        educatorName: widget.name,
                        description:
                            "A comprehensive physics course for JEE/NEET.",
                        durationText: "6 Months",
                        price: 2999,
                        oldPrice: 4999,
                        imageUrl: widget.imageUrl,
                      ),
                    ),
                  );
                },
                imageUrl: widget.imageUrl,
              ),
              CourseCard(
                title: "Physics Crash Course",
                educatorName: widget.name,
                description: "A Fast-track physics course for JEE-Advance/NEET",
                durationText: "2 Months",
                price: 1999,
                oldPrice: 2999,
                onEnroll: () {},
                onViewDetails: () {},
                imageUrl: widget.imageUrl,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// ---------------- TEST SERIES SECTION ----------------
  Widget _buildTestSeriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Available Test Series",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),

        SizedBox(
          height:
              MediaQuery.of(context).size.height *
              0.42, // Adjust height for cards
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              TestSeriesCard(
                imageUrl: widget.imageUrl,
                courseTitle: "JEE Mains Mock Tests",
                instructorName: widget.name,
                qualification: widget.education,
                subject: widget.subject,
                totalTests: 20,
                fee: "₹499",
                onEnroll: () {
                  // Handle enroll
                },
                onViewDetails: () {
                  // Handle view details
                },
              ),
              const SizedBox(width: 12),
              TestSeriesCard(
                imageUrl: widget.imageUrl,
                courseTitle: "NEET Full Length Tests",
                instructorName: widget.name,
                qualification: widget.education,
                subject: widget.subject,
                totalTests: 15,
                fee: "₹699",
                onEnroll: () {
                  // Handle enroll
                },
                onViewDetails: () {
                  // Handle view details
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// ---------------- ABOUT SECTION ----------------
  Widget _buildAboutCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "About the Educator",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              widget.description,
              style: const TextStyle(color: Colors.black87, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}
