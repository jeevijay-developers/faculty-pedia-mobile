import 'package:facultypedia/components/custom_drawer.dart';
import 'package:facultypedia/router/router.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
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
    if (mounted) {
      setState(() {
        token = prefs.getString("token");
        userId = prefs.getString("userId");
        name = prefs.getString("name") ?? "User Name";
        email = prefs.getString("email") ?? "example@email.com";
        mobile = prefs.getString("mobile") ?? "0000000000";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.menu, color: theme.colorScheme.primary, size: 16),
          ),
          onPressed: () => scaffoldKey.currentState?.openDrawer(),
        ),
        title: Text(
          "My Profile",
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.settings,
                color: theme.colorScheme.primary,
                size: 20,
              ),
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: const CustomDrawer(),
      body: token == null || userId == null
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  theme.colorScheme.primary,
                ),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Hero Section with Profile Info
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          theme.cardColor,
                          theme.colorScheme.primary.withOpacity(0.05),
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                      child: Column(
                        children: [
                          Text(
                            "👤 My Profile",
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Manage your account information and preferences",
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.hintColor,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 32),
                          Container(
                            decoration: BoxDecoration(
                              color: theme.cardColor,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: theme.shadowColor.withOpacity(0.08),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: theme.colorScheme.primary
                                              .withOpacity(0.2),
                                          width: 3,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: theme.colorScheme.primary
                                                .withOpacity(0.2),
                                            blurRadius: 20,
                                            offset: const Offset(0, 8),
                                          ),
                                        ],
                                      ),
                                      child: CircleAvatar(
                                        radius: 60,
                                        backgroundColor: theme.cardColor,
                                        child: Icon(
                                          Icons.person,
                                          size: 60,
                                          color: theme.colorScheme.primary,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: theme.colorScheme.primary,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: theme.cardColor,
                                            width: 2,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.verified,
                                          color: theme.colorScheme.onPrimary,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  name ?? "User Name",
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    "ID: ${userId ?? 'N/A'}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Personal Information Section
                  _buildModernSection(
                    theme,
                    "Personal Information",
                    "Your account details and contact information",
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          _buildInfoCard(
                            theme,
                            "Full Name",
                            name ?? "Not provided",
                            Icons.person_outline,
                            theme.colorScheme.primary,
                          ),
                          const SizedBox(height: 16),
                          _buildInfoCard(
                            theme,
                            "Email Address",
                            email ?? "Not provided",
                            Icons.email_outlined,
                            Colors.purple,
                          ),
                          const SizedBox(height: 16),
                          _buildInfoCard(
                            theme,
                            "Mobile Number",
                            mobile ?? "Not provided",
                            Icons.phone_outlined,
                            Colors.orange,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Account Actions Section
                  _buildModernSection(
                    theme,
                    "Account Settings",
                    "Manage your account and preferences",
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          _buildActionCard(
                            theme,
                            "Edit Profile",
                            "Update your personal information",
                            Icons.edit_outlined,
                            theme.colorScheme.primary,
                            () {
                              Navigator.pushNamed(
                                context,
                                AppRouter.updateProfile,
                                arguments: {"token": token, "userId": userId},
                              ).then((_) => _loadProfile());
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildActionCard(
                            theme,
                            "Change Password",
                            "Update your account password",
                            Icons.lock_outline,
                            Colors.purple,
                            () {},
                          ),
                          const SizedBox(height: 16),
                          _buildActionCard(
                            theme,
                            "Notification Settings",
                            "Manage your notification preferences",
                            Icons.notifications_outlined,
                            Colors.blue,
                            () {},
                          ),
                          const SizedBox(height: 16),
                          _buildActionCard(
                            theme,
                            "Privacy Settings",
                            "Control your privacy and data settings",
                            Icons.privacy_tip_outlined,
                            Colors.indigo,
                            () {},
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Support Section
                  _buildModernSection(
                    theme,
                    "Support & Help",
                    "Get assistance and manage your account",
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          _buildActionCard(
                            theme,
                            "Help Center",
                            "Find answers to common questions",
                            Icons.help_outline,
                            Colors.teal,
                            () {},
                          ),
                          const SizedBox(height: 16),
                          _buildActionCard(
                            theme,
                            "Contact Support",
                            "Get in touch with our support team",
                            Icons.support_agent_outlined,
                            Colors.green,
                            () {},
                          ),
                          const SizedBox(height: 16),
                          _buildActionCard(
                            theme,
                            "Logout",
                            "Sign out of your account",
                            Icons.logout_outlined,
                            Colors.red,
                            () {
                              _showLogoutDialog(theme);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }

  Widget _buildModernSection(
    ThemeData theme,
    String title,
    String subtitle,
    Widget content,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          content,
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    ThemeData theme,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    ThemeData theme,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.hintColor,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: theme.hintColor, size: 16),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(ThemeData theme) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: theme.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text("Logout", style: theme.textTheme.headlineSmall),
          content: Text(
            "Are you sure you want to logout from your account?",
            style: theme.textTheme.bodyLarge,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: theme.hintColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                if (mounted) {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, AppRouter.login);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Logout",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
