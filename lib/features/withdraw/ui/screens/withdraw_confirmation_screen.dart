import 'package:flutter/material.dart';
import '../widgets/withdraw_header.dart';
import '../widgets/confirmation_details.dart';
import '../widgets/withdraw_button.dart';

class WithdrawConfirmationScreen extends StatelessWidget {
  final String phoneNumber;
  final int pointsToWithdraw;
  final int fees;
  final String paymentMethod;

  const WithdrawConfirmationScreen({
    super.key,
    required this.phoneNumber,
    required this.pointsToWithdraw,
    required this.fees,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                WithdrawHeader(
                  title: 'تفاصيل التحويل',
                  showBackButton: true,
                  onBackPressed: () => Navigator.pop(context),
                ),
                const SizedBox(height: 32),
                Expanded(
                  child: ConfirmationDetails(
                    phoneNumber: phoneNumber,
                    pointsToWithdraw: pointsToWithdraw,
                    fees: fees,
                    paymentMethod: paymentMethod,
                  ),
                ),
                const SizedBox(height: 24),
                WithdrawButton(
                  label: 'تحويل الان',
                  onPressed: () {
                    // Handle withdrawal confirmation
                    _processWithdrawal(context);
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _processWithdrawal(BuildContext context) {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2A9578)),
        ),
      ),
    );

    // Simulate processing
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // Close loading dialog
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('تم تنفيذ عملية السحب بنجاح'),
          backgroundColor: const Color(0xFF2A9578),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

      // Navigate back to main withdraw screen
      Navigator.pop(context);
    });
  }
}

