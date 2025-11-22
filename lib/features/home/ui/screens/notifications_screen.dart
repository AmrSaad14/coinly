import 'package:coinly/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('الإشعارات'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          separatorBuilder: (context, index) {
            return Padding(padding: EdgeInsets.symmetric(vertical: 10.h));
          },
          itemCount: 10,
          itemBuilder: (context, index) {
            return Container(
              width: 340.w,
              height: 95.h,
              decoration: BoxDecoration(
                color: AppColors.neutral100,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 8.h,
                ),
                leading: Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: AppColors.primary500.withAlpha(70),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.message_outlined,
                    color: AppColors.primary500,
                  ),
                ),
                title: Text(
                  'أحد المستخدمين تلقّى فكة وتم تحديث رصيده',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  'استمر على نفس الوتيرة لتحقيق المزيد',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
