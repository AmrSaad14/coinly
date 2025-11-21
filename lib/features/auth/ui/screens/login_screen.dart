import 'package:coinly/core/router/app_router.dart';
import 'package:coinly/core/theme/app_assets.dart';
import 'package:coinly/core/theme/app_colors.dart';
import 'package:coinly/core/widgets/custom_button.dart';
import 'package:coinly/core/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'تسجيل الدخول',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 20.h),
              CustomTextField(
                controller: TextEditingController(),
                hint: 'البريد الإلكتروني',
                suffixIconWidget: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Image.asset(
                    AppAssets.email,
                    width: 20.w,
                    height: 20.h,
                    fit: BoxFit.contain,
                  ),
                ),
                onChanged: (value) {},
              ),
              SizedBox(height: 20.h),
              CustomTextField(
                controller: TextEditingController(),
                hint: 'كلمة المرور',
                suffixIconWidget: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Image.asset(
                    AppAssets.passKey,
                    width: 20.w,
                    height: 20.h,
                    fit: BoxFit.contain,
                  ),
                ),
                obscureText: true,
                showVisibilityToggle: true,
                visibilityToggleOnPrefix: true,
                onChanged: (value) {},
              ),
              SizedBox(height: 20.h),
              CustomButton(
                text: 'تسجيل الدخول',
                onTap: () {
                  AppRouter.pushNamed(context, AppRouter.selectUserRole);
                },
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      AppRouter.pushNamed(context, AppRouter.phoneAuth);
                    },
                    child: Text(
                      'تسجيل حساب جديد',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary500,
                      ),
                    ),
                  ),
                  Text(
                    'لا تمتلك حساب؟',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
