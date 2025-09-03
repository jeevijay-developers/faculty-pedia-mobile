import 'package:facultypedia/components/custom_drawer.dart';
import 'package:facultypedia/router/router.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

const kPrimary = Color(0xFF4A90E2);

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? token;
  String? userId;
  String? name;
  String? email;
  String? mobile;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("token");
      userId = prefs.getString("userId");
      name = prefs.getString("name") ?? "User Name";
      email = prefs.getString("email") ?? "example@email.com";
      mobile = prefs.getString("mobile") ?? "0000000000";
    });
  }

  Widget _buildInfoCard(String label, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [Colors.white, Colors.grey.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: kPrimary.withOpacity(0.15),
            child: Icon(icon, color: kPrimary, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      drawer: CustomDrawer(),
      key: scaffoldKey,
      backgroundColor: Colors.grey[50],
      body: token == null || userId == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                // Gradient Header
                Container(
                  height: 280,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [kPrimary, Color(0xFF6C63FF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                ),

                SafeArea(
                  child: Column(
                    children: [
                      // Appbar
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const FaIcon(
                                FontAwesomeIcons.bars,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                scaffoldKey.currentState?.openDrawer();
                              },
                            ),
                            const Text(
                              "My Profile",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 40),
                          ],
                        ),
                      ),

                      // Avatar
                      const SizedBox(height: 20),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Colors.white, Colors.white70],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 55,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.person,
                              size: 65,
                              color: kPrimary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Info Cards
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              _buildInfoCard("Name", name ?? "", Icons.person),
                              _buildInfoCard("Email", email ?? "", Icons.email),
                              _buildInfoCard(
                                "Mobile",
                                mobile ?? "",
                                Icons.phone,
                              ),
                              const SizedBox(height: 90),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Floating Edit Button
                Positioned(
                  bottom: 30,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRouter.updateProfile,
                          arguments: {"token": token, "userId": userId},
                        ).then((_) => _loadProfile());
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 40,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF4A90E2), Color(0xFF6C63FF)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueAccent.withOpacity(0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.edit, color: Colors.white, size: 22),
                            SizedBox(width: 10),
                            Text(
                              "Edit Profile",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
