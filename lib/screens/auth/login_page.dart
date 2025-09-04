import 'package:facultypedia/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/auth_bloc.dart';
import 'bloc/auth_event.dart';
import 'bloc/auth_state.dart';

const Color kPrimaryColor = Color(0xFF4A90E2);

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late AnimationController _animationController;

  bool _obscurePassword = true; // for password toggle

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("Login successful!")));
            // Navigate to home page after successful login
            Navigator.pushReplacementNamed(context, AppRouter.home);
          } else if (state is AuthFailure) {
            String userFriendlyMessage = _getUserFriendlyErrorMessage(
              state.error,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(userFriendlyMessage),
                backgroundColor: Colors.red[600],
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ✅ App Logo
                      Image.asset(
                        "assets/images/fp.png", // change path if needed
                        height: 150,
                      ),
                      const SizedBox(height: 16),

                      const Text(
                        "Welcome Back",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Login to continue",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 24),

                      // Email field
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.email_outlined),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Password field with toggle
                      TextField(
                        controller: passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: "Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Login button or loader
                      SizedBox(
                        width: double.infinity,
                        child: state is AuthLoading
                            ? const Center(child: CircularProgressIndicator())
                            : ScaleTransition(
                                scale: Tween(begin: 1.0, end: 0.95).animate(
                                  CurvedAnimation(
                                    parent: _animationController,
                                    curve: Curves.easeInOut,
                                  ),
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: kPrimaryColor,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 3,
                                  ),
                                  onPressed: () {
                                    String email = emailController.text.trim();
                                    String password = passwordController.text
                                        .trim();

                                    // Validate if both fields are empty
                                    if (email.isEmpty && password.isEmpty) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: const Text(
                                            "All fields are required",
                                          ),
                                          backgroundColor: Colors.orange[600],
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                      );
                                      return;
                                    }

                                    // Validate if email is empty
                                    if (email.isEmpty) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: const Text(
                                            "Email is required",
                                          ),
                                          backgroundColor: Colors.orange[600],
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                      );
                                      return;
                                    }

                                    // Validate if password is empty
                                    if (password.isEmpty) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: const Text(
                                            "Password is required",
                                          ),
                                          backgroundColor: Colors.orange[600],
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                      );
                                      return;
                                    }

                                    _animationController.forward().then((_) {
                                      _animationController.reverse();
                                    });
                                    context.read<AuthBloc>().add(
                                      LoginRequested(email, password),
                                    );
                                  },
                                  child: const Text(
                                    "Login",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(height: 16),

                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            AppRouter.signup,
                          );
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: kPrimaryColor,
                        ),
                        child: const Text(
                          "Don't have an account? Sign up",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _getUserFriendlyErrorMessage(String backendError) {
    // Convert backend errors to user-friendly messages
    String lowerError = backendError.toLowerCase();

    if (lowerError.contains('invalid') ||
        lowerError.contains('wrong') ||
        lowerError.contains('incorrect') ||
        lowerError.contains('credential')) {
      return "Invalid email or password. Please try again.";
    } else if (lowerError.contains('user not found') ||
        lowerError.contains('not found')) {
      return "No account found with this email.";
    } else if (lowerError.contains('network') ||
        lowerError.contains('connection') ||
        lowerError.contains('timeout')) {
      return "Network error. Please check your connection.";
    } else if (lowerError.contains('email') && lowerError.contains('format')) {
      return "Please enter a valid email address.";
    } else if (lowerError.contains('password') && lowerError.contains('weak')) {
      return "Password is too weak. Please choose a stronger password.";
    } else if (lowerError.contains('too many') ||
        lowerError.contains('limit')) {
      return "Too many login attempts. Please try again later.";
    } else if (lowerError.contains('server') || lowerError.contains('500')) {
      return "Server error. Please try again later.";
    } else if (lowerError.contains('forbidden') || lowerError.contains('403')) {
      return "Access denied. Please contact support.";
    } else if (lowerError.contains('unauthorized') ||
        lowerError.contains('401')) {
      return "Invalid credentials. Please try again.";
    } else {
      // For any other errors, show a generic message
      return "Something went wrong. Please try again.";
    }
  }
}
