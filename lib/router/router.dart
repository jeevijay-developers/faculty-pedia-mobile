import 'package:facultypedia/screens/blogs/blog_screen.dart';
import 'package:facultypedia/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:facultypedia/screens/auth/login_page.dart';
import 'package:facultypedia/screens/auth/signup_page.dart';
import 'package:facultypedia/screens/home/home.dart';
import 'package:facultypedia/screens/educators/educators_page.dart';
import 'package:facultypedia/screens/courses/courses_screen.dart';
import 'package:facultypedia/screens/help&support/help_home.dart';
import 'package:facultypedia/screens/profile/update_profile.dart';

class AppRouter {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String educators = '/educators';
  static const String courses = '/courses';
  static const String help = '/help';
  static const String profile = '/profile';
  static const String updateProfile = '/updateProfile';
  static const String blog = '/blog';


  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case signup:
        return MaterialPageRoute(builder: (_) => const SignupPage());
      case home:
        return MaterialPageRoute(builder: (_) => const MyHomePage());
      case educators:
        return MaterialPageRoute(builder: (_) => const EducatorsPage());
      case courses:
        return MaterialPageRoute(builder: (_) => const CoursesPage());
      case help:
        return MaterialPageRoute(builder: (_) => const HelpHome());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      case updateProfile:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => UpdateProfilePage(
            token: args['token'],
            userId: args['userId'],
          ),
        );
      case blog:
        return MaterialPageRoute(builder: (_) => const BlogScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('No route defined')),
          ),
        );
    }
  }
}
