import 'package:facultypedia/components/custom_drawer.dart';
import 'package:facultypedia/components/exam_button.dart';
import 'package:facultypedia/components/feature_button.dart';
import 'package:facultypedia/components/mytext.dart';
import 'package:facultypedia/screens/exams/cbse/cbse_home.dart';
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyText(text: "Exam"),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ExamButton(width: width, text: "IIT-JEE", onTap: () {}),
              ExamButton(width: width, text: "NEET", onTap: () {}),
              ExamButton(
                width: width,
                text: "CBSE",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CBSEHome()),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 20),
          MyText(text: "Features"),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FeatureButton(
                icon: FontAwesomeIcons.computer,
                width: width / 2.3,
                text: "Online Courses",
                onTap: () {},
                height: height,
              ),
              FeatureButton(
                icon: FontAwesomeIcons.person,
                width: width / 2.3,
                text: "1v1 Live Classes",
                onTap: () {},
                height: height,
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FeatureButton(
                icon: FontAwesomeIcons.computer,
                width: width / 2.3,
                text: "Webinars",
                onTap: () {},
                height: height,
              ),
              FeatureButton(
                icon: FontAwesomeIcons.person,
                width: width / 2.3,
                text: "Study Materials",
                onTap: () {},
                height: height,
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FeatureButton(
                icon: FontAwesomeIcons.person,
                width: width / 1.12,
                text: "Online Tests",
                onTap: () {},
                height: height,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
