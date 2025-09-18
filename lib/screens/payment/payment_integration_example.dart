// Example of how to integrate PaymentScreen with CourseDetailsPage
// Add this import at the top of course_details_page.dart:
// import '../../router/payment_routes.dart';

// Replace the ElevatedButton onPressed in _bottomEnrollBar method with this:

/*
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: theme.colorScheme.primary,
    foregroundColor: theme.colorScheme.onPrimary,
    elevation: 0,
    padding: const EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  ),
  onPressed: () {
    // Navigate to payment screen
    PaymentRoutes.navigateToPayment(
      context,
      itemTitle: title, // Course title
      itemDescription: 'Complete course with certification', 
      amount: price, // Course price
      imageUrl: imageUrl, // Course image URL
    );
  },
  child: Text(
    "Enroll Now",
    style: theme.textTheme.titleMedium?.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: theme.colorScheme.onPrimary,
    ),
  ),
),
*/

// Also update the app's main.dart to include payment routes:
// Add this to your MaterialApp routes or onGenerateRoute

/*
// In main.dart, add to routes:
routes: {
  ...PaymentRoutes.getRoutes(),
  // ... other routes
},
*/

// Example usage from any screen:
/*
PaymentRoutes.navigateToPayment(
  context,
  itemTitle: 'Premium Course Access',
  itemDescription: 'Unlock all premium features and courses',
  amount: 2999.0,
  imageUrl: 'https://example.com/course-image.jpg',
);
*/
