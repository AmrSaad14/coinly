import 'package:coinly/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class KioskCard extends StatelessWidget {
  final String name;
  final String balance;
  final String debt;

  const KioskCard({
    super.key,
    required this.name,
    required this.balance,
    required this.debt,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with delete icon and name
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
                ),
                child: const Icon(
                  Icons.delete_outline,
                  color: Color(0xFFE74C3C),
                  size: 22,
                ),
              ),
              Spacer(),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.right,
              ),
              SizedBox(width: 10),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.neutral300,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: const Icon(
                    Icons.store,
                    color: AppColors.neutral100,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Monthly Points Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Monthly Points
              RichText(
                textAlign: TextAlign.right,
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 13,
                    fontFamily: 'Cairo',
                    height: 1.5,
                  ),
                  children: [
                    const TextSpan(
                      text: 'نقاط الشهر: ',
                      style: TextStyle(
                        color: Color(0xFF616161),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: balance,
                      style: const TextStyle(
                        color: Color(0xFF2A9578),
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Debt
              RichText(
                textAlign: TextAlign.right,
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 13,
                    fontFamily: 'Cairo',
                    height: 1.5,
                  ),
                  children: [
                    const TextSpan(
                      text: 'الدين المستحقة: ',
                      style: TextStyle(
                        color: Color(0xFF9E9E9E),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: debt,
                      style: const TextStyle(
                        color: AppColors.primaryTeal,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Manage Button
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: AppColors.neutral100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: AppColors.neutral300, width: 1),
                ),
              ),
              child: const Text(
                'ادارة',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.neutral300,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
