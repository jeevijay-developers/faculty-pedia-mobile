import 'package:facultypedia/components/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpHome extends StatefulWidget {
  const HelpHome({super.key});

  @override
  State<HelpHome> createState() => _HelpHomeState();
}

class _HelpHomeState extends State<HelpHome> {
  Future<void> _launchUrl(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _launchFacebook() async {
    final Uri fbApp = Uri.parse("fb://page/101045905588617");
    final Uri fbWeb = Uri.parse("https://www.facebook.com/facultypedia");
    if (await canLaunchUrl(fbApp)) {
      await launchUrl(fbApp, mode: LaunchMode.externalApplication);
    } else {
      await _launchUrl(fbWeb);
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFFF7F9FC),
      drawer: const CustomDrawer(),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 🔹 Hero Section
          // 🔹 Hero Section - Improved Top Bar
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            elevation: 6,
            backgroundColor: Colors.transparent,
            flexibleSpace: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF4A90E2),
                      Color.fromARGB(255, 168, 209, 250),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: FlexibleSpaceBar(
                  centerTitle: true,
                  titlePadding: const EdgeInsets.only(bottom: 16),
                  title: const Text(
                    "Help & Support",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  background: Center(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white24, width: 1),
                      ),
                      child: Image.asset("assets/images/fp.png", height: 80),
                    ),
                  ),
                ),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () => scaffoldKey.currentState?.openDrawer(),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // 🔹 About Us expandable
                  _expandableCard(
                    title: "About Us",
                    icon: FontAwesomeIcons.circleInfo,
                    content:
                        "Facultypedia is committed to providing quality education and resources. "
                        "Our mission is to empower students with structured learning and expert guidance. "
                        "We believe in innovation, accessibility, and student success.",
                  ),
                  const SizedBox(height: 16),

                  // 🔹 Contact Us expandable
                  _expandableCard(
                    title: "Contact Us",
                    icon: FontAwesomeIcons.phone,
                    content:
                        "📞 Phone: +91 80007 93693\n"
                        "📧 Email: nucleonorder@gmail.com\n\n"
                        "🏢 Address:\nC304 Om Enclave, Anantpura,\nKota, Rajasthan, 324005",
                    extra: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _socialButton(
                            FontAwesomeIcons.facebookF,
                            Colors.blue,
                            _launchFacebook,
                          ),
                          const SizedBox(width: 12),
                          _socialButton(
                            FontAwesomeIcons.instagram,
                            Colors.purple,
                            () => _launchUrl(
                              Uri.parse(
                                "https://www.instagram.com/facultypedia",
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          _socialButton(
                            FontAwesomeIcons.youtube,
                            Colors.red,
                            () => _launchUrl(
                              Uri.parse(
                                "https://www.youtube.com/@facultypedia",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Expandable Card
  Widget _expandableCard({
    required String title,
    required IconData icon,
    required String content,
    Widget? extra,
  }) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.withOpacity(0.1),
          child: FaIcon(icon, color: Colors.blue, size: 18),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              content,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.4,
              ),
            ),
          ),
          if (extra != null) extra,
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  // 🔹 Social Buttons
  Widget _socialButton(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: CircleAvatar(
        radius: 24,
        backgroundColor: color.withOpacity(0.15),
        child: FaIcon(icon, color: color, size: 20),
      ),
    );
  }
}
