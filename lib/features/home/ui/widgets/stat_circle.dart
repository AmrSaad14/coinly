import 'package:coinly/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatCircle extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const StatCircle({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: const BoxDecoration(
            color: AppColors.neutral1000,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: const Color(0xFF2A9578), size: 32),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.primary600,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
