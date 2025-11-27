import 'package:coinly/core/router/app_router.dart';
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
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Stack(
                children: [
                  const Center(
                    child: Icon(
                      Icons.notifications_none,
                      color: Color(0xFF2A9578),
                      size: 24,
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

          // Profile Picture (RIGHT)
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: ClipOval(
              child: Container(
                color: const Color(0xFFE8E8E8),
                child: const Icon(
                  Icons.person,
                  color: Color(0xFF9E9E9E),
                  size: 26,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
