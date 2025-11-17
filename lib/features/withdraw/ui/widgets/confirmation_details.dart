import 'package:flutter/material.dart';
import 'detail_row.dart';

class ConfirmationDetails extends StatelessWidget {
  final String phoneNumber;
  final int pointsToWithdraw;
  final int fees;
  final String paymentMethod;

  const ConfirmationDetails({
    super.key,
    required this.phoneNumber,
    required this.pointsToWithdraw,
    required this.fees,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DetailRow(
            label: 'رقم الهاتف',
            value: phoneNumber,
          ),
          const SizedBox(height: 20),
          const Divider(height: 1, color: Color(0xFFE0E0E0)),
          const SizedBox(height: 20),
          DetailRow(
            label: 'النقاط المراد تحويلها',
            value: pointsToWithdraw.toString(),
          ),
          const SizedBox(height: 20),
          const Divider(height: 1, color: Color(0xFFE0E0E0)),
          const SizedBox(height: 20),
          DetailRow(
            label: 'الرسوم',
            value: fees.toString(),
          ),
          const SizedBox(height: 20),
          const Divider(height: 1, color: Color(0xFFE0E0E0)),
          const SizedBox(height: 20),
          DetailRow(
            label: 'وسيلة التحويل',
            value: paymentMethod,
          ),
        ],
      ),
    );
  }
}

