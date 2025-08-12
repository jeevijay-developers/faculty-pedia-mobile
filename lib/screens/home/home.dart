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
            MyText(text: "Exam"),
            SizedBox(height: 10),
            SizedBox(
              height: 220, // Height of the card section
              child: ListView(
                scrollDirection: Axis.horizontal, // Horizontal scrolling
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
                  const SizedBox(width: 10),
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
                  const SizedBox(width: 10),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FeatureCard(
                  icon: FontAwesomeIcons.computer,

                  onTap: () {},
                  title: 'Online Classes',
                  subtitle: 'Attend interactive classes from anywhere, anytime',
                ),
                SizedBox(width: 10),
                FeatureCard(
                  icon: FontAwesomeIcons.computer,

                  onTap: () {},
                  title: '1 on 1 Live classes',
                  subtitle: 'Personalized sessions for focused learning',
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FeatureCard(
                  icon: FontAwesomeIcons.computer,

                  onTap: () {},
                  title: 'Webinars',
                  subtitle: 'Live expert discussions and sessions',
                ),
                SizedBox(width: 10),
                FeatureCard(
                  icon: FontAwesomeIcons.computer,

                  onTap: () {},
                  title: 'Study Material',
                  subtitle: 'High-quality notes, PDFs, and resources',
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FeatureCard(
                  icon: Icons.computer,
                  title: "Online Tests",
                  subtitle:
                      "Evaluate yourself with real-time tests and analytics",
                  onTap: () {},
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
