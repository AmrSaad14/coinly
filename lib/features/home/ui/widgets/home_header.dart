import 'package:coinly/core/router/app_router.dart';
import 'package:coinly/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/owner_data_model.dart';
import 'balance_summary_card.dart';

class HomeHeader extends StatelessWidget {
  final OwnerDataModel? ownerData;

  const HomeHeader({super.key, this.ownerData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Notification Bell Icon (LEFT)
          InkWell(
            onTap: () {
              AppRouter.pushNamed(context, AppRouter.notifications);
            },
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.textGray.withValues(alpha: 0.24),
                shape: BoxShape.circle,
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      Icons.notifications_none,
                      color: AppColors.neutral100,
                      size: 16.sp,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE74C3C),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Spacer(),

          // Greeting Text (CENTER-RIGHT)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                ownerData != null ? 'مرحباً، ${ownerData!.fullName}' : 'مرحباً',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'عرض سريع لعملياتك المالية اليوم',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12.sp,
                  height: 1.3,
                ),
              ),
            ],
          ),

          const SizedBox(width: 12),
        ],
      ),
    );
  }
}
