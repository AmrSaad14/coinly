import 'package:coinly/core/router/app_router.dart';
import 'package:coinly/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddWorkerBanner extends StatelessWidget {
  const AddWorkerBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: InkWell(
        onTap: () {
          AppRouter.pushNamed(context, AppRouter.addWorker);
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.primary500.withValues(alpha: .24),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              const Icon(
                Icons.arrow_back_ios,
                size: 18,
                color: Color(0xFF2A9578),
              ),

              SizedBox(width: 8.w),

              Expanded(
                child: Text(
                  textAlign: TextAlign.right,
                  maxLines: 2,
                  'يمكنك الآن إضافة عامل جديد ومشاركته في إدارة الكشك',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textDark,
                  ),
                ),
              ),

              SizedBox(width: 10.w),

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
        ),
      ),
    );
  }
}
