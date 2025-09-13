     import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:facultypedia/screens/auth/bloc/auth_bloc.dart';
import 'package:facultypedia/screens/auth/bloc/auth_state.dart';
import 'package:facultypedia/router/router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  StreamSubscription<AuthState>? _sub;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    // After first frame, check current AuthBloc state and navigate accordingly.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = context.read<AuthBloc>();

      // Immediate check of current state
      _handleState(bloc.state);

      // Also subscribe to future state changes (in case the check event processes after build)
      _sub = bloc.stream.listen((state) {
        _handleState(state);
      });
    });
  }

  void _handleState(AuthState state) {
    if (_navigated) return;

    if (state is AuthAuthenticated) {
      _navigated = true;
      Navigator.pushReplacementNamed(context, AppRouter.home);
    } else if (state is AuthInitial) {
      _navigated = true;
      Navigator.pushReplacementNamed(context, AppRouter.login);
    }
    // For other states (loading/failure) remain on splash until resolved
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo or branding
            Image.asset("assets/images/fp.png", height: 120),
            const SizedBox(height: 24),
            const Text(
              'Faculty Pedia',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A90E2),
              ),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(color: Color(0xFF4A90E2)),
            const SizedBox(height: 16),
            const Text(
              'Loading...',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
