import 'package:facultypedia/screens/auth/bloc/auth_bloc.dart';
import 'package:facultypedia/screens/auth/bloc/auth_event.dart';
import 'package:facultypedia/screens/auth/bloc/auth_state.dart';
import 'package:facultypedia/screens/live_test/live_test_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:facultypedia/router/router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/snackbar_utils.dart';

const Color kPrimaryColor = Color(0xFF4A90E2);

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer>
    with TickerProviderStateMixin {
  String _name = 'Guest User';
  String _email = '';
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideAnimation = Tween<double>(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('name') ?? 'Guest User';
      _email = prefs.getString('email') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        print("Auth state changed: ${state.runtimeType}");
        if (state is LogoutSuccess) {
          print("Logout success detected");
          SnackBarUtils.showSuccess(context, 'Logged out successfully!');
          // Navigate to login screen
          Navigator.pushReplacementNamed(context, AppRouter.login);
        } else if (state is AuthFailure) {
          print("Auth failure detected: ${state.error}");
          SnackBarUtils.showError(context, 'Logout failed: ${state.error}');
        }
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(_slideAnimation.value * 300, 0),
            child: Opacity(
              opacity: _fadeAnimation.value,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
                child: Drawer(
                  child: Container(
                    color: theme.scaffoldBackgroundColor,
                    child: Column(
                      children: [
                        // Enhanced Header with decorative elements
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(24, 40, 24, 32),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            boxShadow: [
                              BoxShadow(
                                color: theme.shadowColor.withOpacity(0.05),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Avatar section with status indicator
                              Stack(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: theme.colorScheme.surface,
                                      boxShadow: [
                                        BoxShadow(
                                          color: theme.shadowColor.withOpacity(
                                            0.08,
                                          ),
                                          blurRadius: 15,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: theme.colorScheme.surface,
                                          width: 3,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: theme.shadowColor
                                                .withOpacity(0.06),
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: CircleAvatar(
                                        radius: 42,
                                        backgroundColor: theme.cardColor,
                                        backgroundImage: const AssetImage(
                                          'assets/images/fp.png',
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Online status indicator
                                  Positioned(
                                    bottom: 8,
                                    right: 8,
                                    child: Container(
                                      width: 16,
                                      height: 16,
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.secondary,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: theme.cardColor,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              // Name and email with better typography
                              Text(
                                _name,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              if (_email.isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary
                                        .withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    _email,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.primary
                                          .withOpacity(0.85),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 16),
                              // Edit profile button
                              Container(
                                decoration: BoxDecoration(
                                  color: theme.cardColor,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: theme.shadowColor.withOpacity(
                                        0.04,
                                      ),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(20),
                                    onTap: () => Navigator.pushNamed(
                                      context,
                                      AppRouter.profile,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.edit_rounded,
                                            size: 16,
                                            color: theme.colorScheme.primary,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            'Edit Profile',
                                            style: theme.textTheme.bodyMedium
                                                ?.copyWith(
                                                  color:
                                                      theme.colorScheme.primary,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
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
                        ),

                        const SizedBox(height: 20),

                        // Enhanced Menu Items with staggered animation
                        Expanded(
                          child: ListView(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 16,
                            ),
                            children: [
                              _buildEnhancedCardItem(
                                Icons.home_rounded,
                                'Home',
                                'Dashboard & Overview',
                                0,
                                () => Navigator.pushReplacementNamed(
                                  context,
                                  AppRouter.home,
                                ),
                              ),
                              _buildEnhancedCardItem(
                                FontAwesomeIcons.chalkboardUser,
                                'Educators',
                                'Browse Teachers',
                                1,
                                () => Navigator.pushReplacementNamed(
                                  context,
                                  AppRouter.educators,
                                ),
                              ),
                              _buildEnhancedCardItem(
                                Icons.favorite_rounded,
                                'Following',
                                'Followed Educators',
                                2,
                                () => Navigator.pushNamed(
                                  context,
                                  AppRouter.followedEducators,
                                ),
                              ),
                              _buildEnhancedCardItem(
                                Icons.person_rounded,
                                'Profile',
                                'Manage Account',
                                3,
                                () => Navigator.pushNamed(
                                  context,
                                  AppRouter.profile,
                                ),
                              ),
                              _buildEnhancedCardItem(
                                FontAwesomeIcons.book,
                                'Courses',
                                'Learning Materials',
                                4,
                                () => Navigator.pushReplacementNamed(
                                  context,
                                  AppRouter.courses,
                                ),
                              ),
                              _buildEnhancedCardItem(
                                FontAwesomeIcons.video,
                                'Webinars',
                                'Live Learning Sessions',
                                5,
                                () => Navigator.pushReplacementNamed(
                                  context,
                                  AppRouter.webinars,
                                ),
                              ),
                              _buildEnhancedCardItem(
                                FontAwesomeIcons.clipboardList,
                                'Test Series',
                                'Practice & Assessment',
                                6,
                                () => Navigator.pushReplacementNamed(
                                  context,
                                  AppRouter.testSeries,
                                ),
                              ),
                              _buildEnhancedCardItem(
                                FontAwesomeIcons.stopwatch,
                                'Live Tests',
                                'Attempt Live Tests',
                                7,
                                () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const LiveTestListScreen(),
                                    ),
                                  );
                                },
                              ),
                              _buildEnhancedCardItem(
                                Icons.article_rounded,
                                'Blogs',
                                'Educational Articles',
                                8,
                                () => Navigator.pushNamed(
                                  context,
                                  AppRouter.blog,
                                ),
                              ),
                              _buildEnhancedCardItem(
                                Icons.settings_rounded,
                                'Settings',
                                'App Preferences',
                                9,
                                () => Navigator.pushNamed(
                                  context,
                                  AppRouter.settings,
                                ),
                              ),
                              _buildEnhancedCardItem(
                                Icons.info_outline_rounded,
                                'About Company',
                                'Learn More',
                                10,
                                () => Navigator.pushReplacementNamed(
                                  context,
                                  AppRouter.help,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Enhanced Logout Button
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: LinearGradient(
                                colors: [
                                  Theme.of(
                                    context,
                                  ).colorScheme.error.withOpacity(0.06),
                                  Theme.of(
                                    context,
                                  ).colorScheme.error.withOpacity(0.12),
                                ],
                              ),
                              border: Border.all(
                                color: Theme.of(
                                  context,
                                ).colorScheme.error.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () {
                                  _showLogoutDialog(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 20,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.logout_rounded,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.error,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Logout',
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.error,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEnhancedCardItem(
    IconData icon,
    String title,
    String subtitle,
    int index,
    VoidCallback onTap,
  ) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final theme = Theme.of(context);
        // Limit the delay to prevent scroll-based fade issues
        final delay = (index * 0.05).clamp(0.0, 0.5);
        final animationValue = Curves.easeOutCubic.transform(
          (_animationController.value - delay).clamp(0.0, 1.0),
        );

        return Transform.translate(
          offset: Offset(0, (1 - animationValue) * 30),
          child: Opacity(
            // Ensure minimum opacity to prevent complete fade out
            opacity: animationValue.clamp(0.8, 1.0),
            child: Container(
              margin: const EdgeInsets.only(bottom: 4),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: onTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            icon,
                            color: theme.colorScheme.primary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.2,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                subtitle,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.dividerColor.withOpacity(0.9),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: theme.dividerColor,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(
                Icons.logout_rounded,
                color: Theme.of(context).colorScheme.error,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Confirm Logout',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to logout from your account?',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(
                context,
              ).textTheme.bodyMedium?.color?.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).dividerColor.withOpacity(0.9),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog

                // Trigger logout through AuthBloc
                print("Triggering logout through AuthBloc");
                context.read<AuthBloc>().add(LogoutRequested());
              },
              child: const Text(
                'Logout',
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
