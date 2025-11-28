import 'package:coinly/core/di/injection_container.dart' as di;
import 'package:coinly/core/router/app_router.dart';
import 'package:coinly/core/theme/app_colors.dart';
import 'package:coinly/features/kiosk/logic/create_kiosk_cubit.dart';
import 'package:coinly/features/kiosk/logic/create_kiosk_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CreatekioskScreen extends StatefulWidget {
  const CreatekioskScreen({super.key});

  @override
  State<CreatekioskScreen> createState() => _CreatekioskScreenState();
}

class _CreatekioskScreenState extends State<CreatekioskScreen> {
  final TextEditingController _kioskNameController = TextEditingController();
  final TextEditingController _kioskCategoryController =
      TextEditingController();
  final TextEditingController _kioskLocationController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Map Arabic categories to English kind values
  String _mapCategoryToKind(String category) {
    final categoryLower = category.toLowerCase().trim();
    if (categoryLower.contains('وجبات خفيفة') ||
        categoryLower.contains('خفيفة')) {
      return 'small';
    } else if (categoryLower.contains('صحف') ||
        categoryLower.contains('مجلات') ||
        categoryLower.contains('medium')) {
      return 'medium';
    } else if (categoryLower.contains('أطعمة') ||
        categoryLower.contains('مشروبات') ||
        categoryLower.contains('large')) {
      return 'large';
    } else if (categoryLower.contains('اخري') ||
        categoryLower.contains('أخرى') ||
        categoryLower.contains('other')) {
      return 'other';
    }
    return 'small'; // default
  }

  @override
  void dispose() {
    _kioskNameController.dispose();
    _kioskCategoryController.dispose();
    _kioskLocationController.dispose();
    super.dispose();
  }

  void _createStore(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      if (_kioskCategoryController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('الرجاء إدخال تصنيف الكشك'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      context.read<CreateKioskCubit>().createKiosk(
        name: _kioskNameController.text.trim(),
        kind: _mapCategoryToKind(_kioskCategoryController.text.trim()),
        location: _kioskLocationController.text.trim(),
      );
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Verified Icon
                  SvgPicture.asset(
                    'assets/icons/verified.svg',
                    width: 100,
                    height: 100,
                  ),
                  const SizedBox(height: 24),
                  // Success Message
                  const Text(
                    'تم اضافة الكشك بنجاح',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  // Go to Home Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close dialog
                        AppRouter.pushNamedAndRemoveUntil(
                          context,
                          AppRouter.home,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryTeal,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'دخول الرئيسيه',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<CreateKioskCubit>(),
      child: BlocListener<CreateKioskCubit, CreateKioskState>(
        listener: (context, state) {
          if (state is CreateKioskSuccess) {
            _showSuccessDialog(context);
          } else if (state is CreateKioskError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: const Text(
                'إنشاء كشك',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Welcome message
                      Text(
                        ' قم بإنشاء كشك جديد ',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        textAlign: TextAlign.center,
                        ' ابدأ بإضافة تفاصيل الكشك الخاص بك. يمكنك تعديلها في أي وقت لاحقًا ',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textGray,
                        ),
                      ),
                      SizedBox(height: 16.h),

                      Column(
                        children: [
                          // Kiosk Name
                          _buildTextField(
                            controller: _kioskNameController,
                            label: 'اسم الكشك',
                            prefixIcon: Icons.storefront,
                            hint: 'مثال: كشك الإلكترونيات',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'الرجاء إدخال اسم الكشك';
                              }
                              if (value.length < 3) {
                                return 'اسم الكشك يجب أن يكون 3 أحرف على الأقل';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 16),

                          // Kiosk Category
                          _buildTextField(
                            controller: _kioskCategoryController,
                            label: 'تصنيف الكشك',
                            prefixIcon: Icons.category,
                            hint:
                                'مثال: وجبات خفيفة، صحف ومجلات، أطعمة ومشروبات، أخرى',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'الرجاء إدخال تصنيف الكشك';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 16),

                          // Kiosk Location
                          _buildTextField(
                            controller: _kioskLocationController,
                            label: 'موقع الكشك',
                            prefixIcon: Icons.location_on,
                            hint: 'مثال: شارع التحرير، القاهرة',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'الرجاء إدخال موقع الكشك';
                              }
                              if (value.length < 5) {
                                return 'الموقع يجب أن يكون 5 أحرف على الأقل';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 32),

                          // Create Store Button
                          BlocBuilder<CreateKioskCubit, CreateKioskState>(
                            builder: (context, state) {
                              final isLoading = state is CreateKioskLoading;
                              return SizedBox(
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: isLoading
                                      ? null
                                      : () => _createStore(context),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryTeal,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: isLoading
                                      ? const SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.white,
                                                ),
                                          ),
                                        )
                                      : const Text(
                                          'إنشاء الكشك',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 16),

                          // Skip button
                          TextButton(
                            onPressed: () {
                              // Skip store creation and go to home
                              AppRouter.pushNamedAndRemoveUntil(
                                context,
                                AppRouter.home,
                              );
                            },
                            child: Text(
                              'تخطي الآن، سأقوم بإنشائه لاحقاً',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData prefixIcon,
    String? hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(color: Colors.grey),
        hintStyle: TextStyle(color: Colors.grey[400]),
        prefixIcon: Icon(prefixIcon, color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryTeal, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        filled: true,
        fillColor: AppColors.scaffoldBackground,
      ),
    );
  }
}
