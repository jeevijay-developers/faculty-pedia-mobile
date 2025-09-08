import 'package:facultypedia/components/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

const Color kPrimaryColor = Color(0xFF4A90E2);

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
      backgroundColor: Colors.grey[50],
      drawer: const CustomDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: kPrimaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.menu, color: kPrimaryColor, size: 20),
          ),
          onPressed: () => scaffoldKey.currentState?.openDrawer(),
        ),
        title: const Text(
          "Help & Support",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, kPrimaryColor.withOpacity(0.05)],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                child: Column(
                  children: [
                    // Welcome Icon
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: kPrimaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: kPrimaryColor.withOpacity(0.2),
                        ),
                      ),
                      child: Image.asset("assets/images/fp.png", height: 80),
                    ),
                    const SizedBox(height: 20),

                    // Welcome Text
                    const Text(
                      "We're here to help!",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Get support, learn about us, or get in touch",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            // About Us Section
            _buildModernSection(
              "About Us",
              "Learn more about our mission and vision",
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Card(
                  elevation: 8,
                  shadowColor: Colors.black.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.white, kPrimaryColor.withOpacity(0.02)],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: kPrimaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: FaIcon(
                                FontAwesomeIcons.circleInfo,
                                color: kPrimaryColor,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Text(
                              "Our Story",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Facultypedia is committed to providing quality education and resources. "
                          "Our mission is to empower students with structured learning and expert guidance. "
                          "We believe in innovation, accessibility, and student success.",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[700],
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Contact Us Section
            _buildModernSection(
              "Contact Us",
              "Reach out to us for any support or queries",
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Card(
                  elevation: 8,
                  shadowColor: Colors.black.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.white, kPrimaryColor.withOpacity(0.02)],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: kPrimaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: FaIcon(
                                FontAwesomeIcons.phone,
                                color: kPrimaryColor,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Text(
                              "Get in Touch",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Contact Items
                        _buildContactItem(
                          Icons.phone,
                          "Phone",
                          "+91 80007 93693",
                          null,
                        ),
                        const SizedBox(height: 16),
                        _buildContactItem(
                          Icons.email,
                          "Email",
                          "nucleonorder@gmail.com",
                          null,
                        ),
                        const SizedBox(height: 16),
                        _buildContactItem(
                          Icons.location_on,
                          "Address",
                          "C304 Om Enclave, Anantpura,\nKota, Rajasthan, 324005",
                          null,
                        ),

                        const SizedBox(height: 32),

                        // Social Media
                        const Text(
                          "Follow us on",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _socialButton(
                              FontAwesomeIcons.facebookF,
                              Colors.blue,
                              "Facebook",
                              _launchFacebook,
                            ),
                            _socialButton(
                              FontAwesomeIcons.instagram,
                              Colors.purple,
                              "Instagram",
                              () => _launchUrl(
                                Uri.parse(
                                  "https://www.instagram.com/facultypedia",
                                ),
                              ),
                            ),
                            _socialButton(
                              FontAwesomeIcons.youtube,
                              Colors.red,
                              "YouTube",
                              () => _launchUrl(
                                Uri.parse(
                                  "https://www.youtube.com/@facultypedia",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // Modern Section Builder
  Widget _buildModernSection(String title, String subtitle, Widget content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Section Content
          content,
        ],
      ),
    );
  }

  // Contact Item Builder
  Widget _buildContactItem(
    IconData icon,
    String label,
    String value,
    VoidCallback? onTap,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: kPrimaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: kPrimaryColor, size: 18),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (onTap != null) Icon(Icons.chevron_right, color: Colors.grey[400]),
        ],
      ),
    );
  }

  // Social Button Builder
  Widget _socialButton(
    IconData icon,
    Color color,
    String label,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withOpacity(0.2)),
            ),
            child: FaIcon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
