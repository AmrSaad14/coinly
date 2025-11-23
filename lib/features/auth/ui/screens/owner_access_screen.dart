import 'package:coinly/core/router/app_router.dart';
import 'package:coinly/core/theme/app_assets.dart';
import 'package:coinly/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class OwnerAccessScreen extends StatelessWidget {
  const OwnerAccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AppAssets.ownerAccessImage,
                fit: BoxFit.contain,
                height: 250.h,
              ),
              Text(
                'نشكرك علي استخدام تطبيق كشكي',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8.h),
              Text(
                'سنقوم بالتواصل معك لتاكيد البيانات الخاصة بك',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 8.h),
              Text(
                'عادة ما نقوم بالتواصل معك في غضون 24 ساعة',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 16.h),
              CustomButton(
                text: 'للتواصل معنا عبر واتساب',
                onTap: () {
                  launchUrl(Uri.parse('https://wa.me/+201158883085'));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
