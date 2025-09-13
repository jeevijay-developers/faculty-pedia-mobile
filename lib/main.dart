import 'package:facultypedia/config/app.dart';
import 'package:facultypedia/screens/auth/bloc/auth_bloc.dart';
import 'package:facultypedia/screens/auth/bloc/auth_event.dart';
import 'package:facultypedia/screens/auth/repository/auth_repository.dart';
import 'package:facultypedia/screens/blogs/bloc/blog_bloc.dart';
import 'package:facultypedia/screens/blogs/repository/blog_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:facultypedia/config/theme_controller.dart';

Future<void> main() async {
  final authRepository = AuthRepository();
  WidgetsFlutterBinding.ensureInitialized();
  // Load saved theme before running the app so initial theme is correct
  await ThemeController.loadTheme();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              AuthBloc(authRepository)..add(CheckAuthStatusRequested()),
        ),
        BlocProvider(
          create: (context) => BlogBloc(
            repository: BlogRepository(
              token: '',
            ), // You may need to get token from auth state
          ),
        ),
      ],
      child: (const MyApp()),
    ),
  );
}
