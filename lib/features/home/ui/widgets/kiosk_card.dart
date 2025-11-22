import 'package:coinly/core/router/app_router.dart';
import 'package:coinly/core/theme/app_assets.dart';
import 'package:coinly/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

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
              InkWell(
                onTap: () {},
                child: SvgPicture.asset(
                  AppAssets.deleteIcon,
                  width: 20.w,
                  height: 20.h,
                ),
              ),
              Spacer(),
              Text(
                name,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
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
          SizedBox(height: 10.h),
          // Monthly Points Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Monthly Points
              RichText(
                textAlign: TextAlign.right,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMedium,
                    height: 1.5,
                  ),
                  children: [
                    TextSpan(
                      text: 'نقاط الشهر: ',
                      style: TextStyle(
                        color: Color(0xFF616161),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: balance,
                      style: TextStyle(
                        color: Color(0xFF2A9578),
                        fontWeight: FontWeight.w700,
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10.h),

              // Debt
              RichText(
                textAlign: TextAlign.right,
                text: TextSpan(
                  style: TextStyle(fontSize: 14.sp, height: 1.5),
                  children: [
                    TextSpan(
                      text: 'الدين المستحقة: ',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Color(0xFF9E9E9E),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: debt,
                      style: TextStyle(
                        fontSize: 14.sp,
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
              onPressed: () {
                AppRouter.pushNamed(context, AppRouter.manageKiosk);
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: AppColors.neutral100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: AppColors.neutral300, width: 1),
                ),
              ),
              child: Text(
                'ادارة',
                style: TextStyle(
                  fontSize: 12.sp,
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
