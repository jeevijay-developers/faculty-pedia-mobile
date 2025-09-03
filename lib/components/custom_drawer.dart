import 'package:facultypedia/screens/auth/bloc/auth_bloc.dart';
import 'package:facultypedia/screens/auth/bloc/auth_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:facultypedia/router/router.dart';
import 'package:shared_preferences/shared_preferences.dart';

const kPrimary = Color(0xFF4A90E2);
const kAccent = Color(0xFF6C63FF);

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String name = "User Name";
  String email = "example@email.com";

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString("name") ?? "User Name";
      email = prefs.getString("email") ?? "example@email.com";
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(40),
        bottomRight: Radius.circular(40),
      ),
      child: Drawer(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1E1E2C), Color(0xFF23233A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              // Profile Section with Shadowed Avatar
              Container(
                padding: const EdgeInsets.only(top: 50, bottom: 20),
                child: Column(
                  children: [
                    Container(
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
                      child: const CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage("assets/images/fp.png"),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      name, // ✅ Use the state variable
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      email, // ✅ Use the state variable
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(color: Colors.white24, thickness: 0.5),

              // Menu Items
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  children: [
                    _buildMenuItem(
                      Icons.home_rounded,
                      "Home",
                      context,
                      AppRouter.home,
                    ),
                    _buildMenuItem(
                      FontAwesomeIcons.chalkboardUser,
                      "Educators",
                      context,
                      AppRouter.educators,
                    ),
                    _buildMenuItem(
                      Icons.person_rounded,
                      "Profile",
                      context,
                      AppRouter.profile,
                    ),
                    _buildMenuItem(
                      FontAwesomeIcons.book,
                      "Courses",
                      context,
                      AppRouter.courses,
                    ),
                    _buildMenuItem(
                      Icons.article,
                      "Blogs",
                      context,
                      AppRouter.blog,
                    ),
                    _buildMenuItem(
                      Icons.help_outline_rounded,
                      "About Company",
                      context,
                      AppRouter.help,
                    ),
                  ],
                ),
              ),

              // Logout Button with Gradient Shadow
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: const LinearGradient(
                      colors: [Colors.redAccent, Colors.red],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.redAccent.withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    icon: const Icon(Icons.logout_rounded, color: Colors.white),
                    label: const Text(
                      "Logout",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    onPressed: () {
                      context.read<AuthBloc>().add(LogoutRequested());
                      Navigator.pushReplacementNamed(context, AppRouter.login);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title,
    BuildContext context,
    String? route,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      onTap: () {
        if (route != null) {
          Navigator.pushReplacementNamed(context, route);
        }
      },
      hoverColor: Colors.white10,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      horizontalTitleGap: 10,
      minLeadingWidth: 20,
    );
  }
}
