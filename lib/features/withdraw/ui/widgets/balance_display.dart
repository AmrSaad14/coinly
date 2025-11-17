import 'package:coinly/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class BalanceDisplay extends StatelessWidget {
  final int currentBalance;
  final int pointValue;
  final int coinValue;

  const BalanceDisplay({
    super.key,
    required this.currentBalance,
    required this.pointValue,
    required this.coinValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.neutralGrey,
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'الرصيد الحالي',
            style: TextStyle(fontSize: 14, color: Color(0xFF757575)),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'نقطه',
                style: TextStyle(fontSize: 16, color: Color(0xFF757575)),
              ),
              const SizedBox(width: 8),
              Text(
                '$currentBalance',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 8),

              const SizedBox(width: 8),
              Text(
                textDirection: TextDirection.rtl,
                '$coinValue جنيه ',
                style: const TextStyle(fontSize: 14, color: Color(0xFF757575)),
              ),
              const SizedBox(width: 8),
              const Text(
                '=',
                style: TextStyle(fontSize: 14, color: Color(0xFF757575)),
              ),
              const SizedBox(width: 8),
              Text(
                'كل $pointValue نقطة',
                style: const TextStyle(fontSize: 14, color: Color(0xFF757575)),
              ),
              const SizedBox(width: 8),
              const Text('💰', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 16),
            ],
          ),
        ],
      ),
    );
  }
}
