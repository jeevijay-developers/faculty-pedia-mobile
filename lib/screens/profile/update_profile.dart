import 'dart:ui';
import 'package:facultypedia/screens/auth/bloc/auth_bloc.dart';
import 'package:facultypedia/screens/auth/bloc/auth_event.dart';
import 'package:facultypedia/screens/auth/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

const kPrimary = Color(0xFF4A90E2);
const kAccent = Color(0xFF6C63FF);

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
    setState(() {
      _oldName = prefs.getString("name") ?? "";
      _oldEmail = prefs.getString("email") ?? "";
      _oldMobile = prefs.getString("mobile") ?? "";

      nameController.text = _oldName;
      emailController.text = _oldEmail;
      mobileController.text = _oldMobile;
    });
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
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            setState(() => _showSuccess = true);
            Future.delayed(const Duration(seconds: 2), () {
              Navigator.pop(context);
            });
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Column(
                children: [
                  // Gradient Header with curved bottom
                  Container(
                    height: 220,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [kPrimary, kAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                    child: SafeArea(
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                          const Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(
                                "Update Profile",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 40),
                              child: CircleAvatar(
                                radius: 55,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.person,
                                  size: 60,
                                  color: kPrimary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Info Text
                  const Text(
                    "Tap fields below to edit your details",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Form Card
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _buildModernField(
                              controller: nameController,
                              label: "Full Name",
                              icon: Icons.person,
                              validator: (v) =>
                                  v == null || v.isEmpty ? "Required" : null,
                            ),
                            const SizedBox(height: 18),
                            _buildModernField(
                              controller: emailController,
                              label: "Email",
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) {
                                final value = (v ?? "").trim();
                                final emailReg = RegExp(
                                  r"^[^\s@]+@[^\s@]+\.[^\s@]+$",
                                );
                                return emailReg.hasMatch(value)
                                    ? null
                                    : "Enter valid email";
                              },
                            ),
                            const SizedBox(height: 18),
                            _buildModernField(
                              controller: mobileController,
                              label: "Mobile",
                              icon: Icons.phone,
                              keyboardType: TextInputType.phone,
                              validator: (v) {
                                final value = (v ?? "").trim();
                                return value.length == 10 &&
                                        RegExp(r'^\d+$').hasMatch(value)
                                    ? null
                                    : "Enter 10-digit mobile";
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Floating Save Button
              Positioned(
                bottom: 30,
                left: 20,
                right: 20,
                child: AnimatedScale(
                  scale: _hasChanges ? 1 : 0.95,
                  duration: const Duration(milliseconds: 300),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _hasChanges ? kPrimary : Colors.grey,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 10,
                      shadowColor: kPrimary.withOpacity(0.4),
                    ),
                    onPressed: _hasChanges && state is! AuthLoading
                        ? () => _onUpdatePressed(context)
                        : null,
                    child: state is AuthLoading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            "Save Changes",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),

              // Success Animation
              if (_showSuccess)
                Container(
                  color: Colors.black54,
                  child: Center(
                    child: Lottie.asset(
                      "assets/lottie/success.json",
                      repeat: false,
                      width: 200,
                      height: 200,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildModernField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: kPrimary),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: kPrimary, width: 2),
        ),
      ),
      validator: validator,
    );
  }
}
