import 'package:facultypedia/screens/blogs/blog_screen.dart';
import 'package:facultypedia/screens/profile/profile_screen.dart';
import 'package:facultypedia/screens/splash/splash_screen.dart';
import 'package:facultypedia/screens/webinars/webinars_screen.dart';
import 'package:facultypedia/screens/test_series/test_series_screen.dart';
                                                                                                                                                                                                                                                                          import 'package:facultypedia/screens/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:facultypedia/screens/auth/login_page.dart';
import 'package:facultypedia/screens/auth/signup_page.dart';
import 'package:facultypedia/screens/home/home.dart';
import 'package:facultypedia/screens/educators/educators_page.dart';
import 'package:facultypedia/screens/educators/followed_educators_screen.dart';
import 'package:facultypedia/screens/courses/courses_screen.dart';
import 'package:facultypedia/screens/courses/courses_category_screen.dart';
import 'package:facultypedia/screens/help&support/help_home.dart';
import 'package:facultypedia/screens/profile/update_profile.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String educators = '/educators';
  static const String courses = '/courses';
  static const String coursesCategory = '/coursesCategory';
  static const String webinars = '/webinars';
  static const String testSeries = '/testSeries';
  static const String help = '/help';
  static const String settings = '/settings';
  static const String profile = '/profile';
  static const String updateProfile = '/updateProfile';
  static const String blog = '/blog';
  static const String followedEducators = '/followedEducators';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case signup:
        return MaterialPageRoute(builder: (_) => const SignupPage());
      case home:
        return MaterialPageRoute(builder: (_) => const MyHomePage());
      case educators:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => EducatorsPage(preselectedCategory: args?['category']),
        );
      case courses:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => CoursesPage(preselectedCategory: args?['category']),
        );
      case coursesCategory:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => CoursesCategoryScreen(
            category: args?['category'] ?? 'All',
            categoryTitle: args?['categoryTitle'],
          ),
        );
      case webinars:
        return MaterialPageRoute(builder: (_) => const WebinarsScreen());
      case testSeries:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) =>
              TestSeriesScreen(preselectedCategory: args?['category']),
        );
      case help:
        return MaterialPageRoute(builder: (_) => const HelpHome());
      case '/settings':
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      case updateProfile:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) =>
              UpdateProfilePage(token: args['token'], userId: args['userId']),
        );
      case blog:
        return MaterialPageRoute(builder: (_) => const BlogScreen());
      case followedEducators:
        return MaterialPageRoute(builder: (_) => const FollowedEducatorsScreen());
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('No route defined'))),
        );
    }
  }
}
