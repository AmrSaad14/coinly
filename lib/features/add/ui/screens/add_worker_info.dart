import 'package:coinly/core/router/app_router.dart';
import 'package:coinly/core/theme/app_assets.dart';
import 'package:coinly/core/widgets/app_dialog.dart';
import 'package:coinly/core/widgets/custom_button.dart';
import 'package:coinly/features/withdraw/ui/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddWorkerInfoScreen extends StatelessWidget {
  const AddWorkerInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('اضافة عامل جديد'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              CustomTextField(
                label: 'اسم العامل',
                placeholder: 'ادخل اسم العامل',
                controller: TextEditingController(),
              ),
              SizedBox(height: 12.h),
              CustomTextField(
                label: 'رقم الموبايل',
                placeholder: 'ادخل رقم الموبايل',
                controller: TextEditingController(),
              ),
              SizedBox(height: 12.h),
              CustomTextField(
                label: ' الوظيفة',
                placeholder: 'ادخل الوظيفة',
                controller: TextEditingController(),
              ),
              SizedBox(height: 12.h),
              CustomTextField(
                label: 'ساعات العمل',
                placeholder: 'ادخل ساعات العمل',
                controller: TextEditingController(),
              ),
              SizedBox(height: 48.h),
              CustomButton(
                width: double.infinity,
                text: 'اضافة العامل',
                onTap: () {
                  showAppDialog(
                    imageAsset: AppAssets.verifiedIcon,
                    context: context,
                    title: 'تم اضافة العامل بنجاح',
                    primaryButtonText: 'الرجوع للرئيسية',
                    onPrimaryPressed: () {
                      AppRouter.pushNamed(context, AppRouter.home);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
