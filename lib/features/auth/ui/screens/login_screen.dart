import 'package:coinly/core/router/app_router.dart';
import 'package:coinly/core/theme/app_assets.dart';
import 'package:coinly/core/theme/app_colors.dart';
import 'package:coinly/core/widgets/custom_button.dart';
import 'package:coinly/core/widgets/custom_text_field.dart';
import 'package:coinly/features/auth/logic/cubit/cubit/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
          context.read<LoginCubit>().clearError();
        }

        switch (state.action) {
          case LoginFlowAction.home:
            AppRouter.pushNamedAndRemoveUntil(context, AppRouter.home);
            context.read<LoginCubit>().clearAction();
            break;
          case LoginFlowAction.createKiosk:
            AppRouter.pushNamedAndRemoveUntil(context, AppRouter.createKiosk);
            context.read<LoginCubit>().clearAction();
            break;
          case LoginFlowAction.ownerAccess:
            AppRouter.pushNamed(context, AppRouter.ownerAccess);
            context.read<LoginCubit>().clearAction();
            break;
          case LoginFlowAction.blockedUser:
            AppRouter.pushNamed(context, AppRouter.blockedUser);
            context.read<LoginCubit>().clearAction();
            break;
          case LoginFlowAction.none:
            break;
        }
      },
      child: BlocBuilder<LoginCubit, LoginState>(
        builder: (context, state) {
          final loginCubit = context.read<LoginCubit>();

          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 40.h),
                        Text(
                          'تسجيل الدخول',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 40.h),
                        CustomTextField(
                          controller: _phoneController,
                          hint: 'رقم الهاتف',
                          suffixIconWidget: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            child: Icon(
                              Icons.phone_outlined,
                              size: 20.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'الرجاء إدخال رقم الهاتف';
                            }
                            if (value.trim().length < 9) {
                              return 'رقم الهاتف غير صحيح';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20.h),
                        CustomTextField(
                          controller: _passwordController,
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
                        ),
                        SizedBox(height: 40.h),
                        CustomButton(
                          text: 'تسجيل الدخول',
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            if (_formKey.currentState!.validate()) {
                              loginCubit.login(
                                username: _phoneController.text.trim(),
                                password: _passwordController.text,
                              );
                            }
                          },
                          isLoading: state.isLoading,
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                AppRouter.pushNamed(
                                  context,
                                  AppRouter.phoneAuth,
                                );
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
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 40.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
