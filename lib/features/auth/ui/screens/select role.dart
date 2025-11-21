import 'package:coinly/core/router/app_router.dart';
import 'package:coinly/core/theme/app_assets.dart';
import 'package:coinly/core/theme/app_colors.dart';
import 'package:coinly/core/widgets/app_dialog.dart';
import 'package:coinly/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectUserRoleScreen extends StatelessWidget {
  const SelectUserRoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'هيا بنا لنبدأ رحتلك بالتطبيق',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 16.h),
              Text(
                'يرجى اختيار مسار الدخول المناسب لك للمتابعة',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 16.h),
              Image.asset(
                AppAssets.roleImage,
                fit: BoxFit.contain,
                height: 250.h,
              ),
              SizedBox(height: 16.h),
              CustomButton(
                width: 200.w,
                text: 'مالك',
                onTap: () => showAppDialog(
                  context: context,
                  title: 'هل انت متأكد من تسجيل حسابك مالك؟',
                  primaryButtonText: 'تأكيد',
                  onPrimaryPressed: () {
                    AppRouter.pushNamed(context, AppRouter.ownerAccess);
                  },
                  secondaryButtonText: 'إلغاء',
                ),
              ),
              SizedBox(height: 16.h),
              CustomButton(
                width: 200.w,
                backgroundColor: AppColors.scaffoldBackground,
                textColor: AppColors.textGray,
                borderColor: AppColors.textGray,
                text: 'موظف',
                onTap: () => showAppDialog(
                  context: context,
                  title: 'هل انت متأكد من تسجيل حسابك موظف؟',
                  primaryButtonText: 'تأكيد',
                  onPrimaryPressed: () {
                    AppRouter.pushNamed(context, AppRouter.home);
                  },
                  secondaryButtonText: 'إلغاء',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
