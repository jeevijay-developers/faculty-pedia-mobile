import 'package:flutter/material.dart';
import '../screens/payment/payment_screen.dart';

class PaymentRoutes {
  static const String payment = '/payment';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      payment: (context) {
        final args =
            ModalRoute.of(context)!.settings.arguments as PaymentArguments?;

        return PaymentScreen(
          itemTitle: args?.itemTitle ?? 'Course Enrollment',
          itemDescription: args?.itemDescription ?? 'Course enrollment fee',
          amount: args?.amount ?? 0.0,
          imageUrl: args?.imageUrl,
        );
      },
    };
  }

  static Future<void> navigateToPayment(
    BuildContext context, {
    required String itemTitle,
    required String itemDescription,
    required double amount,
    String? imageUrl,
  }) async {
    await Navigator.pushNamed(
      context,
      payment,
      arguments: PaymentArguments(
        itemTitle: itemTitle,
        itemDescription: itemDescription,
        amount: amount,
        imageUrl: imageUrl,
      ),
    );
  }
}

class PaymentArguments {
  final String itemTitle;
  final String itemDescription;
  final double amount;
  final String? imageUrl;

  PaymentArguments({
    required this.itemTitle,
    required this.itemDescription,
    required this.amount,
    this.imageUrl,
  });
}
