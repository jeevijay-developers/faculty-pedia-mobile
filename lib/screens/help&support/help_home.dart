import 'package:facultypedia/components/custom_drawer.dart';
import 'package:facultypedia/components/help_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HelpHome extends StatefulWidget {
  const HelpHome({super.key});

  @override
  State<HelpHome> createState() => _HelpHomeState();
}

class _HelpHomeState extends State<HelpHome> {
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
        title: Image.asset("assets/images/fp.png", height: 50),
        centerTitle: true,
      ),
      drawer: CustomDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          HelpCard(
            title: "About us",
            icon: FontAwesomeIcons.circleInfo,
            details:
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent bibendum tortor ut volutpat blandit. Aliquam molestie lacus sed velit cursus vulputate. Praesent tellus felis, auctor sed felis nec, gravida vulputate magna. Morbi venenatis fermentum justo egestas iaculis. Maecenas aliquam libero nec fringilla efficitur. Praesent tempus diam euismod, condimentum enim a, sodales quam. Fusce vel sapien vel quam pharetra pulvinar. Duis tempor leo vitae ipsum mattis, in scelerisque nibh laoreet. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
          ),
          HelpCard(
            title: "Contact us",
            icon: FontAwesomeIcons.phone,
            details: 'Phone: +91 1234567890',
            subDetails: "Email: test@test.com",
            address: "Address: Delhi, India",
          ),
        ],
      ),
    );
  }
}
