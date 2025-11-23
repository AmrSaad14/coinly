import 'package:coinly/core/di/injection_container.dart' as di;
import 'package:coinly/core/network/api_service.dart';
import 'package:coinly/core/router/app_router.dart';
import 'package:coinly/core/theme/app_assets.dart';
import 'package:coinly/core/theme/app_colors.dart';
import 'package:coinly/core/utils/constants.dart';
import 'package:coinly/core/widgets/custom_button.dart';
import 'package:coinly/core/widgets/custom_text_field.dart';
import 'package:coinly/features/auth/data/models/login_request_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _selectedRole; // 'owner' or 'worker'
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    // Validate fields
    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى إدخال البريد الإلكتروني أو اسم المستخدم'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى إدخال كلمة المرور'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى اختيار نوع المستخدم'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Get role-specific client credentials based on selected role
      final String clientId;
      final String clientSecret;
      final String scope;

      // Ensure role is selected - this should have been validated above, but double check
      if (_selectedRole == 'owner') {
        // Use owner credentials when "مالك" (owner) is selected
        clientId = AppConstants.ownerClientId;
        clientSecret = AppConstants.ownerClientSecret;
        scope = 'owner';
        print('🔵 Selected Role: Owner (مالك)');
      } else if (_selectedRole == 'worker') {
        // Use worker credentials when "عامل" (worker) is selected
        clientId = AppConstants.workerClientId;
        clientSecret = AppConstants.workerClientSecret;
        scope = 'worker';
        print('🔵 Selected Role: Worker (عامل)');
      } else {
        // This shouldn't happen due to validation above, but handle it anyway
        throw Exception('Role not selected');
      }

      // Create login request
      final loginRequest = LoginRequestModel(
        grantType: 'password',
        clientId: clientId,
        clientSecret: clientSecret,
        username: _emailController.text.trim(),
        password: _passwordController.text,
        scope: scope,
      );

      // Debug: Print request details (without password)
      print('🔵 Login Request:');
      print('   Selected Role: $_selectedRole');
      print(
        '   Username (can be email/phone/username): ${loginRequest.username}',
      );
      print('   Scope: ${loginRequest.scope}');
      print('   Client ID: ${loginRequest.clientId.substring(0, 10)}...');
      print('   Grant Type: ${loginRequest.grantType}');
      print('   Request JSON: ${loginRequest.toJson()}');

      // Call login API
      final apiService = di.sl<ApiService>();
      print('🔵 Calling login API...');
      final response = await apiService.login(loginRequest);
      print('✅ Login successful!');
      print(
        '   Access Token: ${response.accessToken?.substring(0, 20) ?? 'null'}...',
      );

      // Store access token
      if (response.accessToken != null) {
        final prefs = di.sl<SharedPreferences>();
        await prefs.setString(AppConstants.accessToken, response.accessToken!);
      }

      // Navigate to home screen
      if (mounted) {
        AppRouter.pushNamedAndRemoveUntil(context, AppRouter.home);
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = 'حدث خطأ أثناء تسجيل الدخول';

        // Log the error for debugging
        print('🔴 Login Error: $e');

        // Handle DioException specifically
        if (e is DioException) {
          print('🔴 DioException Type: ${e.type}');
          print('🔴 Status Code: ${e.response?.statusCode}');
          print('🔴 Response Data: ${e.response?.data}');

          // Handle different Dio error types
          switch (e.type) {
            case DioExceptionType.connectionTimeout:
            case DioExceptionType.sendTimeout:
            case DioExceptionType.receiveTimeout:
              errorMessage = 'انتهت مهلة الاتصال. حاول مرة أخرى';
              break;
            case DioExceptionType.badResponse:
              final statusCode = e.response?.statusCode;
              final responseData = e.response?.data;

              if (statusCode == 401) {
                errorMessage = 'البريد الإلكتروني أو كلمة المرور غير صحيحة';
              } else if (statusCode == 400) {
                // Try to get error message from response
                if (responseData is Map<String, dynamic>) {
                  final message =
                      responseData['message'] ??
                      responseData['error'] ??
                      responseData['error_description'];
                  if (message != null) {
                    errorMessage = message.toString();
                  } else {
                    errorMessage = 'طلب غير صحيح. تحقق من البيانات المدخلة';
                  }
                } else {
                  errorMessage = 'طلب غير صحيح. تحقق من البيانات المدخلة';
                }
              } else if (statusCode == 403) {
                errorMessage = 'ليس لديك صلاحية للوصول';
              } else if (statusCode == 404) {
                errorMessage = 'نقطة الاتصال غير موجودة';
              } else if (statusCode == 500) {
                errorMessage = 'خطأ في الخادم. حاول مرة أخرى لاحقاً';
              } else {
                // Try to get error message from response
                if (responseData is Map<String, dynamic>) {
                  final message =
                      responseData['message'] ??
                      responseData['error'] ??
                      responseData['error_description'];
                  if (message != null) {
                    errorMessage = message.toString();
                  }
                }
              }
              break;
            case DioExceptionType.cancel:
              errorMessage = 'تم إلغاء الطلب';
              break;
            case DioExceptionType.unknown:
            case DioExceptionType.badCertificate:
            case DioExceptionType.connectionError:
              errorMessage = 'تحقق من اتصالك بالإنترنت';
              break;
          }
        } else {
          // Handle other exceptions
          final errorString = e.toString().toLowerCase();
          if (errorString.contains('401') ||
              errorString.contains('unauthorized')) {
            errorMessage = 'البريد الإلكتروني أو كلمة المرور غير صحيحة';
          } else if (errorString.contains('network') ||
              errorString.contains('socket')) {
            errorMessage = 'تحقق من اتصالك بالإنترنت';
          }
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 40.h),
                Text(
                  'تسجيل الدخول',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 40.h),
                CustomTextField(
                  controller: _emailController,
                  hint: 'البريد الإلكتروني أو رقم الهاتف أو اسم المستخدم',
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
                  keyboardType: TextInputType
                      .text, // Can accept email, phone, or username
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
                  onChanged: (value) {},
                ),
                SizedBox(height: 20.h),
                // Role selection buttons
                Text(
                  'نوع المستخدم',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: 'مالك',
                        backgroundColor: _selectedRole == 'owner'
                            ? AppColors.primary500
                            : AppColors.scaffoldBackground,
                        textColor: _selectedRole == 'owner'
                            ? Colors.white
                            : AppColors.textGray,
                        borderColor: _selectedRole == 'owner'
                            ? AppColors.primary500
                            : AppColors.textGray,
                        onTap: () {
                          print(
                            '🔵 Owner button tapped - Setting role to owner',
                          );
                          setState(() {
                            _selectedRole = 'owner';
                          });
                          print('🔵 Current _selectedRole: $_selectedRole');
                        },
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: CustomButton(
                        text: 'عامل',
                        backgroundColor: _selectedRole == 'worker'
                            ? AppColors.primary500
                            : AppColors.scaffoldBackground,
                        textColor: _selectedRole == 'worker'
                            ? Colors.white
                            : AppColors.textGray,
                        borderColor: _selectedRole == 'worker'
                            ? AppColors.primary500
                            : AppColors.textGray,
                        onTap: () {
                          print(
                            '🔵 Worker button tapped - Setting role to worker',
                          );
                          setState(() {
                            _selectedRole = 'worker';
                          });
                          print('🔵 Current _selectedRole: $_selectedRole');
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                CustomButton(
                  text: 'تسجيل الدخول',
                  onTap: _handleLogin,
                  isLoading: _isLoading,
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
    );
  }
}
