import 'package:facultypedia/components/custom_drawer.dart';
import 'package:facultypedia/components/exam_button.dart';
import 'package:facultypedia/components/feature_button.dart';
import 'package:facultypedia/components/mytext.dart';
import 'package:facultypedia/screens/exams/cbse/cbse_home.dart';
import 'package:facultypedia/screens/exams/iit/iit_home.dart';
import 'package:facultypedia/screens/exams/neet/neet_home.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  MyText(text: "Choose your Exam"),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Select your target exam and get access to specialized courses, expert guidance, and comprehensive study materials",
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),

            SizedBox(
              height:
                  MediaQuery.of(context).size.height /
                  1.4, // Height of the card section
              child: Column(
                children: [
                  ExamCard(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const IITHomePage(),
                        ),
                      );
                    },
                    backgroundImage: 'assets/images/iit-bg.png',
                    icon: "assets/images/iit-logo.png",
                    title: "IIT JEE",
                    subtitle: 'Indian Institute of Technology',
                  ),
                  const SizedBox(height: 20),
                  ExamCard(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NeetHomePage(),
                        ),
                      );
                    },
                    backgroundImage: 'assets/images/neet-bg.png',
                    icon: "assets/images/neet-logo.png",
                    title: "NEET",
                    subtitle: 'National Eligibility cum Entrance Exam',
                  ),
                  const SizedBox(height: 20),
                  ExamCard(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CBSEHome(),
                        ),
                      );
                    },
                    backgroundImage: 'assets/images/cbse-bg.png',
                    icon: "assets/images/cbse-logo.png",
                    title: "CBSE",
                    subtitle: 'Central Board of Secondary Education',
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                "Why choose Faculty Pedia",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Explore our comprehensive learning features designed to help you excel in your academic journey",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsetsGeometry.all(8.0),
              child: Column(
                children: [
                  FeatureCard(
                    icon: FontAwesomeIcons.computer,

                    onTap: () {},
                    title: 'Online Classes',
                    subtitle:
                        'Attend interactive classes from anywhere, anytime',
                  ),
                  SizedBox(height: 10),
                  FeatureCard(
                    icon: FontAwesomeIcons.computer,

                    onTap: () {},
                    title: '1 on 1 Live classes',
                    subtitle: 'Personalized sessions for focused learning',
                  ),
                  SizedBox(height: 10),
                  FeatureCard(
                    icon: FontAwesomeIcons.computer,

                    onTap: () {},
                    title: 'Webinars',
                    subtitle: 'Live expert discussions and sessions',
                  ),
                  SizedBox(height: 10),
                  FeatureCard(
                    icon: FontAwesomeIcons.computer,

                    onTap: () {},
                    title: 'Study Material',
                    subtitle: 'High-quality notes, PDFs, and resources',
                  ),
                  SizedBox(height: 10),
                  FeatureCard(
                    icon: Icons.computer,
                    title: "Online Tests",
                    subtitle:
                        "Evaluate yourself with real-time tests and analytics",
                    onTap: () {},
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF155DFC), // Blue background
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Become a FacultyPedia Educator",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 8),

                    const Text(
                      "Share your expertise, inspire learners, and earn for your impact. "
                      "Join our growing network of passionate educators today!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Center(
                      child: SizedBox(
                        width: 120,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF155DFC),
                            elevation: 5,

                            shadowColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () {},
                          child: const Text(
                            "Join",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
