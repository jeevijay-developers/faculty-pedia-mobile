import 'package:flutter/material.dart';
import '../utils/snackbar_utils.dart';

/// Example usage of SnackBarUtils in your app
///
/// Use this as a reference for implementing SnackBars throughout your application
class SnackBarExamples {
  /// Show success message (Green)
  static void showSuccessExample(BuildContext context) {
    SnackBarUtils.showSuccess(context, 'Operation completed successfully!');
  }

  /// Show error message (Red)
  static void showErrorExample(BuildContext context) {
    SnackBarUtils.showError(context, 'Something went wrong. Please try again.');
  }

  /// Show warning message (Orange/Yellow)
  static void showWarningExample(BuildContext context) {
    SnackBarUtils.showWarning(
      context,
      'Please check your internet connection.',
    );
  }

  /// Show info message (Blue)
  static void showInfoExample(BuildContext context) {
    SnackBarUtils.showInfo(context, 'This feature is coming soon!');
  }

  /// Example with custom action button
  static void showWithAction(BuildContext context) {
    SnackBarUtils.showError(
      context,
      'Failed to save data.',
      action: SnackBarAction(
        label: 'RETRY',
        textColor: Colors.white,
        onPressed: () {
          // Handle retry action
          SnackBarUtils.showInfo(context, 'Retrying...');
        },
      ),
    );
  }

  /// Example with custom duration
  static void showWithCustomDuration(BuildContext context) {
    SnackBarUtils.showWarning(
      context,
      'This warning will disappear in 5 seconds.',
      duration: const Duration(seconds: 5),
    );
  }
}

/// Common SnackBar messages used throughout the app
class AppSnackBarMessages {
  // Authentication
  static const String loginSuccess = 'Welcome back! Login successful.';
  static const String loginError = 'Invalid credentials. Please try again.';
  static const String logoutSuccess = 'Logged out successfully.';

  // Network
  static const String networkError =
      'No internet connection. Please check your network.';
  static const String serverError = 'Server error. Please try again later.';
  static const String requestTimeout = 'Request timeout. Please try again.';

  // Data Operations
  static const String saveSuccess = 'Data saved successfully.';
  static const String saveError = 'Failed to save data.';
  static const String deleteSuccess = 'Item deleted successfully.';
  static const String deleteError = 'Failed to delete item.';
  static const String updateSuccess = 'Updated successfully.';
  static const String updateError = 'Failed to update.';

  // Validation
  static const String invalidInput = 'Please check your input and try again.';
  static const String requiredFields = 'Please fill in all required fields.';
  static const String invalidEmail = 'Please enter a valid email address.';
  static const String weakPassword =
      'Password must be at least 8 characters long.';

  // Features
  static const String comingSoon = 'This feature is coming soon!';
  static const String underMaintenance = 'This feature is under maintenance.';

  // Educators/Follow System
  static const String educatorFollowed = 'Educator followed successfully.';
  static const String educatorUnfollowed = 'Educator unfollowed successfully.';
  static const String followError = 'Failed to follow educator.';
  static const String unfollowError = 'Failed to unfollow educator.';

  // Live Tests
  static const String testSubmitted = 'Test submitted successfully.';
  static const String testSubmissionError = 'Failed to submit test.';
  static const String testStarted = 'Test started. Good luck!';
  static const String testCompleted = 'Test completed successfully.';
  static const String resultsSaved = 'Results saved successfully.';
  static const String resultsError = 'Failed to save results.';
}

/// Extension methods for easier SnackBar usage
extension SnackBarExtension on BuildContext {
  void showSuccessSnackBar(String message) {
    SnackBarUtils.showSuccess(this, message);
  }

  void showErrorSnackBar(String message) {
    SnackBarUtils.showError(this, message);
  }

  void showWarningSnackBar(String message) {
    SnackBarUtils.showWarning(this, message);
  }

  void showInfoSnackBar(String message) {
    SnackBarUtils.showInfo(this, message);
  }
}
