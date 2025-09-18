import 'dart:ui';
import 'package:facultypedia/screens/auth/bloc/auth_bloc.dart';
import 'package:facultypedia/screens/auth/bloc/auth_event.dart';
import 'package:facultypedia/screens/auth/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateProfilePage extends StatefulWidget {
  final String token;
  final String userId;

  const UpdateProfilePage({
    super.key,
    required this.token,
    required this.userId,
  });

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();

  String _oldName = "";
  String _oldEmail = "";
  String _oldMobile = "";
  bool _hasChanges = false;
  bool _showSuccess = false;

  @override
  void initState() {
    super.initState();
    _prefillFields();
    _addListeners();
  }

  Future<void> _prefillFields() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _oldName = prefs.getString("name") ?? "";
        _oldEmail = prefs.getString("email") ?? "";
        _oldMobile = prefs.getString("mobile") ?? "";

        nameController.text = _oldName;
        emailController.text = _oldEmail;
        mobileController.text = _oldMobile;
      });
    }
  }

  void _addListeners() {
    nameController.addListener(_checkForChanges);
    emailController.addListener(_checkForChanges);
    mobileController.addListener(_checkForChanges);
  }

  void _checkForChanges() {
    final changed =
        nameController.text.trim() != _oldName.trim() ||
        emailController.text.trim() != _oldEmail.trim() ||
        mobileController.text.trim() != _oldMobile.trim();
    if (changed != _hasChanges) {
      setState(() => _hasChanges = changed);
    }
  }

  void _onUpdatePressed(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    context.read<AuthBloc>().add(
      UpdateProfileRequested(
        widget.token,
        widget.userId,
        nameController.text.trim(),
        emailController.text.trim(),
        mobileController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.arrow_back, color: primaryColor, size: 20),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Update Profile",
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            setState(() => _showSuccess = true);
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) {
                Navigator.pop(context, true); // Return true to indicate success
              }
            });
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: theme.colorScheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            theme.cardColor,
                            primaryColor.withOpacity(0.05),
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                        child: Column(
                          children: [
                            Text(
                              "✏️ Edit Profile",
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Update your personal information and account details",
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.hintColor,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Profile Information Form
                    _buildModernSection(
                      theme,
                      "Personal Information",
                      "Update your personal details below",
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Form(
                          key: _formKey,
                          child: _buildModernFormCard(
                            theme: theme,
                            child: Column(
                              children: [
                                _buildModernField(
                                  theme: theme,
                                  controller: nameController,
                                  label: "Full Name",
                                  icon: Icons.person_outline,
                                  validator: (v) => v == null || v.isEmpty
                                      ? "Name is required"
                                      : null,
                                ),
                                const SizedBox(height: 20),
                                _buildModernField(
                                  theme: theme,
                                  controller: emailController,
                                  label: "Email Address",
                                  icon: Icons.email_outlined,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (v) {
                                    final value = (v ?? "").trim();
                                    final emailReg = RegExp(
                                      r"^[^\s@]+@[^\s@]+\.[^\s@]+$",
                                    );
                                    return emailReg.hasMatch(value)
                                        ? null
                                        : "Enter a valid email address";
                                  },
                                ),
                                const SizedBox(height: 20),
                                _buildModernField(
                                  theme: theme,
                                  controller: mobileController,
                                  label: "Mobile Number",
                                  icon: Icons.phone_outlined,
                                  keyboardType: TextInputType.phone,
                                  validator: (v) {
                                    final value = (v ?? "").trim();
                                    return value.length == 10 &&
                                            RegExp(r'^\d+$').hasMatch(value)
                                        ? null
                                        : "Enter a valid 10-digit mobile number";
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Save Button Section
                    _buildModernSection(
                      theme,
                      "Save Changes",
                      _hasChanges
                          ? "Ready to save your updates"
                          : "Make changes above to enable save",
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            if (_hasChanges)
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle_outline,
                                      color: Colors.green,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        "Changes detected. Tap save to update your profile.",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.green[700],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _hasChanges
                                      ? primaryColor
                                      : theme.disabledColor,
                                  foregroundColor: _hasChanges
                                      ? theme.colorScheme.onPrimary
                                      : theme.textTheme.bodyLarge?.color
                                            ?.withOpacity(0.5),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: _hasChanges ? 2 : 0,
                                ),
                                onPressed: _hasChanges && state is! AuthLoading
                                    ? () => _onUpdatePressed(context)
                                    : null,
                                child: state is AuthLoading
                                    ? SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: theme.colorScheme.onPrimary,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            _hasChanges
                                                ? Icons.save
                                                : Icons.save_outlined,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          const Text(
                                            "Save Changes",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
              if (_showSuccess)
                Container(
                  color: Colors.black54.withOpacity(0.6),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: theme.shadowColor.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Lottie.asset(
                              "assets/lottie/success.json",
                              repeat: false,
                              width: 120,
                              height: 120,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Profile Updated!",
                              style: theme.textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Your profile has been successfully updated.",
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.hintColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
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

  Widget _buildModernFormCard({
    required Widget child,
    required ThemeData theme,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
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
      child: child,
    );
  }

  Widget _buildModernField({
    required ThemeData theme,
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    final primaryColor = theme.colorScheme.primary;
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: theme.textTheme.bodyLarge,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: primaryColor, size: 20),
        ),
        filled: true,
        fillColor: theme.scaffoldBackgroundColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      validator: validator,
    );
  }
}
