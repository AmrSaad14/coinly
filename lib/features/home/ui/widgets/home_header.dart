import 'package:coinly/core/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'balance_summary_card.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Stack(
        children: [
          Container(
            height: 300,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF36A689), Color(0xFF2A9578)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
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
                        'مرحباً، أحمد',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'عرض سريع لعملياتك المالية اليوم',
                        style: TextStyle(
                          color: Colors.white,
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
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2.5),
                    ),
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
            ),
          ),
          const Positioned(
            top: 150,
            left: 10,
            right: 10,
            child: BalanceSummaryCard(),
          ),
        ],
      ),
    );
  }
}
