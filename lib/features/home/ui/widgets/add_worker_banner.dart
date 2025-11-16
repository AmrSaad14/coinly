import 'package:coinly/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AddWorkerBanner extends StatelessWidget {
  const AddWorkerBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary500.withValues(alpha: .29),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(
        children: [
          const Icon(Icons.arrow_back_ios, size: 18, color: Color(0xFF2A9578)),

          const SizedBox(width: 8),

          Expanded(
            child: RichText(
              textAlign: TextAlign.right,
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                  fontFamily: 'Cairo',
                  height: 1.6,
                ),
                children: [
                  TextSpan(text: 'يمكنك '),
                  TextSpan(
                    text: 'الآن',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(text: ' إضافة عامل جديد\nومشاركته في إدارة '),
                  TextSpan(
                    text: 'الكشك',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 10),

          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.person_add_alt_outlined,
              color: Color(0xFF2A9578),
              size: 26,
            ),
          ),
        ],
      ),
    );
  }
}
