import 'package:coinly/core/theme/app_colors.dart';
import 'package:coinly/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Reusable dialog that supports optional imagery, title, description,
/// and one or two action buttons.
class AppDialog extends StatelessWidget {
  const AppDialog({
    super.key,
    required this.title,
    required this.primaryButtonText,
    required this.onPrimaryPressed,
    this.description,
    this.imageAsset,
    this.customImage,
    this.secondaryButtonText,
    this.onSecondaryPressed,
  });

  final String title;
  final String? description;
  final String? imageAsset;
  final Widget? customImage;
  final String primaryButtonText;
  final VoidCallback onPrimaryPressed;
  final String? secondaryButtonText;
  final VoidCallback? onSecondaryPressed;

  Widget? _buildImage() {
    if (customImage != null) return customImage;
    if (imageAsset != null) {
      return Image.asset(imageAsset!, height: 160.h, fit: BoxFit.contain);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final Widget? imageWidget = _buildImage();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: SizedBox(
        width: 300.w,
        height: 260.h,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.h),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (imageWidget != null) ...[
                  imageWidget,
                  SizedBox(height: 30.h),
                ],
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textDark,
                  ),
                ),
                if (description?.isNotEmpty ?? false) ...[
                  SizedBox(height: 12.h),
                  Text(
                    description!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textMedium,
                      height: 1.4,
                    ),
                  ),
                ],
                SizedBox(height: 24.h),
                if (secondaryButtonText != null)
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: secondaryButtonText!,
                          onTap: () {
                            Navigator.of(context).pop();
                            onSecondaryPressed?.call();
                          },
                          backgroundColor: AppColors.scaffoldBackground,
                          textColor: AppColors.textGray,
                          borderColor: AppColors.textGray,
                          height: 52.h,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: CustomButton(
                          text: primaryButtonText,
                          onTap: () {
                            Navigator.of(context).pop();
                            onPrimaryPressed();
                          },
                          backgroundColor: AppColors.primary500,
                          height: 52.h,
                        ),
                      ),
                    ],
                  )
                else
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      text: primaryButtonText,
                      onTap: () {
                        Navigator.of(context).pop();
                        onPrimaryPressed();
                      },
                      backgroundColor: AppColors.primary500,
                      height: 52.h,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<T?> showAppDialog<T>({
  required BuildContext context,
  required String title,
  required String primaryButtonText,
  required VoidCallback onPrimaryPressed,
  String? description,
  String? imageAsset,
  Widget? customImage,
  String? secondaryButtonText,
  VoidCallback? onSecondaryPressed,
  bool barrierDismissible = false,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (_) => AppDialog(
      title: title,
      description: description,
      imageAsset: imageAsset,
      customImage: customImage,
      primaryButtonText: primaryButtonText,
      onPrimaryPressed: onPrimaryPressed,
      secondaryButtonText: secondaryButtonText,
      onSecondaryPressed: onSecondaryPressed,
    ),
  );
}
