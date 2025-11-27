import 'package:coinly/core/theme/app_colors.dart';
import 'package:coinly/core/widgets/custom_text_field.dart';
import 'package:coinly/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dio/dio.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/network/api_service.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/message_extractor.dart';
import '../../data/models/complete_profile_request_model.dart';

class CompleteRegistrationScreen extends StatefulWidget {
  final String phoneNumber;
  final String? role; // 'owner' or 'worker'

  const CompleteRegistrationScreen({
    super.key,
    required this.phoneNumber,
    this.role,
  });

  @override
  State<CompleteRegistrationScreen> createState() =>
      _CompleteRegistrationScreenState();
}

class _CompleteRegistrationScreenState
    extends State<CompleteRegistrationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _jobController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _agreeToTerms = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _jobController.dispose();
    super.dispose();
  }

  void _completeRegistration() async {
    if (_formKey.currentState!.validate()) {
      if (!_agreeToTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('يرجى الموافقة على الشروط والأحكام'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        final user = _auth.currentUser;

        if (user == null) {
          throw Exception('User not authenticated');
        }

        final firebaseUid = user.uid;

        // Get Firebase ID Token for authorization
        String? idToken;
        try {
          idToken = await user.getIdToken();
          print(
            '🔑 Firebase ID Token obtained: ${idToken?.substring(0, 20)}...',
          );
        } catch (e) {
          print('⚠️ Failed to get ID token: $e');
        }

        // Get role-specific client credentials
        final String clientId;
        final String clientSecret;
        final String roleName;

        if (widget.role == 'owner') {
          clientId = AppConstants.ownerClientId;
          clientSecret = AppConstants.ownerClientSecret;
          roleName = 'مالك';
        } else if (widget.role == 'worker') {
          clientId = AppConstants.workerClientId;
          clientSecret = AppConstants.workerClientSecret;
          roleName = 'عامل';
        } else {
          // Fallback to default (should not happen, but for safety)
          clientId = AppConstants.clientId;
          clientSecret = AppConstants.clientSecret;
          roleName = 'غير محدد';
        }

        print('👤 Selected Role: $roleName');
        print('🔑 Using Client ID: ${clientId.substring(0, 20)}...');

        // Create request model
        final request = CompleteProfileRequestModel(
          firebaseUid: firebaseUid,
          clientId: clientId,
          clientSecret: clientSecret,
          user: UserData(
            fullName: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text,
            job: _jobController.text.trim(),
          ),
        );

        // Debug: Print request details
        print('');
        print('═══════════════════════════════════════════════════════════');
        print('🌐 ========== COMPLETE PROFILE API CALL ==========');
        print('═══════════════════════════════════════════════════════════');
        print('');
        print('📱 Phone Number: ${widget.phoneNumber}');
        print('🆔 Firebase UID: $firebaseUid');
        print(
          '🔑 Authorization: ${idToken != null ? "Bearer ${idToken.substring(0, 20)}..." : "None"}',
        );
        print('📦 Request Body:');
        final requestJson = request.toJson();
        // Pretty print the JSON
        print('{');
        requestJson.forEach((key, value) {
          if (value is Map) {
            print('  "$key": {');
            value.forEach((k, v) {
              print('    "$k": "$v"');
            });
            print('  }');
          } else {
            print('  "$key": "$value"');
          }
        });
        print('}');
        print('');
        print(
          '🚀 Sending POST request to: ${AppConstants.baseUrl}/users/complete_profile',
        );
        print('');
        print('═══════════════════════════════════════════════════════════');
        print('');

        // Call API with authorization header
        final apiService = di.sl<ApiService>();
        final authorization = idToken != null ? 'Bearer $idToken' : null;
        final response = await apiService.completeProfile(
          request,
          authorization,
        );

        // Debug: Print response details
        print('');
        print('═══════════════════════════════════════════════════════════');
        print('✅ ========== COMPLETE PROFILE API RESPONSE ==========');
        print('═══════════════════════════════════════════════════════════');
        print('');
        print('📊 Status Code: ${response.statusCode}');
        print('📝 Status Message: ${response.statusMessage}');
        print('🔗 Headers:');
        response.headers.forEach((key, values) {
          print('   $key: ${values.join(", ")}');
        });
        print('');
        print('📦 Response Data:');
        if (response.data != null) {
          if (response.data is Map) {
            print('   Type: Map');
            print('   Content: ${response.data}');
          } else if (response.data is String) {
            print('   Type: String');
            print('   Content: ${response.data}');
          } else {
            print('   Type: ${response.data.runtimeType}');
            print('   Content: ${response.data}');
          }
        } else {
          print('   (No response data)');
        }
        print('');
        print('📋 Response Type: ${response.runtimeType}');
        print('📋 Request Options: ${response.requestOptions.uri}');
        print('📋 Request Method: ${response.requestOptions.method}');
        print('');
        print('═══════════════════════════════════════════════════════════');
        print('');

        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('تم إنشاء الحساب بنجاح'),
              backgroundColor: AppColors.primaryTeal,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );

          // Navigate based on role
          if (widget.role == 'owner') {
            print(
              '👤 Owner registration complete - Navigating to owner access screen',
            );
            AppRouter.pushNamedAndRemoveUntil(context, AppRouter.ownerAccess);
          } else if (widget.role == 'worker') {
            print(
              '👤 Worker registration complete - Navigating to home screen',
            );
            AppRouter.pushNamedAndRemoveUntil(context, AppRouter.home);
          } else {
            // Fallback (should not happen, but for safety)
            print('⚠️ Unknown role - Navigating to home screen');
            AppRouter.pushNamedAndRemoveUntil(context, AppRouter.home);
          }
        }
      } catch (e) {
        print('');
        print('═══════════════════════════════════════════════════════════');
        print('❌ ========== COMPLETE PROFILE API ERROR ==========');
        print('═══════════════════════════════════════════════════════════');
        print('');
        print('❌ Error Type: ${e.runtimeType}');
        print('❌ Error: $e');
        print('');

        // If it's a DioException, show more details
        if (e is DioException) {
          print('📋 DioException Details:');
          print('   Status Code: ${e.response?.statusCode}');
          print('   Status Message: ${e.response?.statusMessage}');
          print('   Request Path: ${e.requestOptions.path}');
          print('   Request Method: ${e.requestOptions.method}');
          print('   Request Data: ${e.requestOptions.data}');
          print('   Request Headers: ${e.requestOptions.headers}');
          print('');
          print('📦 Response Data:');
          if (e.response?.data != null) {
            print('   ${e.response?.data}');
          } else {
            print('   (No response data)');
          }
          print('');
          print('📋 Response Headers:');
          e.response?.headers.forEach((key, values) {
            print('   $key: ${values.join(", ")}');
          });
        } else if (e.toString().contains('DioException') ||
            e.toString().contains('DioError')) {
          print('📋 Error Details:');
          print('   This is a network/HTTP error');
          if (e.toString().contains('401')) {
            print('   Status: 401 Unauthorized');
          } else if (e.toString().contains('403')) {
            print('   Status: 403 Forbidden');
          } else if (e.toString().contains('400')) {
            print('   Status: 400 Bad Request');
          } else if (e.toString().contains('500')) {
            print('   Status: 500 Server Error');
          }
        }
        print('');
        print('═══════════════════════════════════════════════════════════');
        print('');

        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          String errorMessage = 'حدث خطأ أثناء إنشاء الحساب';

          // Check if it's a DioException and extract server error message
          if (e is DioException && e.response?.data != null) {
            // Use MessageExtractor to get error_description or proper error message
            errorMessage = MessageExtractor.extractErrorFromDioException(
              e.response?.data,
            );
          } else {
            // Fallback to status code based messages
            if (e.toString().contains('SocketException') ||
                e.toString().contains('TimeoutException')) {
              errorMessage = 'فشل الاتصال بالخادم. يرجى المحاولة مرة أخرى';
            } else if (e.toString().contains('401')) {
              errorMessage = 'فشل التحقق من المستخدم';
            } else if (e.toString().contains('403')) {
              errorMessage = 'غير مصرح';
            } else if (e.toString().contains('400')) {
              errorMessage = 'بيانات غير صحيحة';
            } else if (e.toString().contains('500')) {
              errorMessage = 'خطأ في الخادم';
            }
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 10),

                  // Title
                  const Text(
                    'إنشاء حساب',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 8),

                  // Subtitle
                  Text(
                    'أكمل بياناتك للمتابعة',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 32),

                  // Name field
                  CustomTextField(
                    controller: _nameController,
                    hint: 'الاسم بالكامل',
                    prefixIcon: Icons.person_outline,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال الاسم';
                      }
                      if (value.length < 3) {
                        return 'الاسم يجب أن يكون 3 أحرف على الأقل';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Email field
                  CustomTextField(
                    controller: _emailController,
                    hint: 'البريد الإلكتروني',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال البريد الإلكتروني';
                      }
                      final emailRegex = RegExp(
                        r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
                      );
                      if (!emailRegex.hasMatch(value)) {
                        return 'البريد الإلكتروني غير صحيح';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Password field
                  CustomTextField(
                    controller: _passwordController,
                    hint: 'كلمة المرور',
                    prefixIcon: Icons.lock_outline,
                    obscureText: true,
                    showVisibilityToggle: true,
                    visibilityToggleOnPrefix: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال كلمة المرور';
                      }
                      if (value.length < 6) {
                        return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Confirm password field
                  CustomTextField(
                    controller: _confirmPasswordController,
                    hint: 'تأكيد كلمة المرور',
                    prefixIcon: Icons.lock_outline,
                    obscureText: true,
                    showVisibilityToggle: true,
                    visibilityToggleOnPrefix: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء تأكيد كلمة المرور';
                      }
                      if (value != _passwordController.text) {
                        return 'كلمة المرور غير متطابقة';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Job field
                  CustomTextField(
                    controller: _jobController,
                    hint: 'المهنة',
                    prefixIcon: Icons.work_outline,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال المهنة';
                      }
                      return null;
                    },
                  ),

                  // Terms and conditions checkbox
                  Row(
                    children: [
                      Checkbox(
                        value: _agreeToTerms,
                        onChanged: (value) {
                          setState(() {
                            _agreeToTerms = value ?? false;
                          });
                        },
                        activeColor: AppColors.primaryTeal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _agreeToTerms = !_agreeToTerms;
                            });
                          },
                          child: Text(
                            'أوافق على جميع الشروط والأحكام',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Register button
                  CustomButton(
                    text: 'إنشاء حساب',
                    onTap: _completeRegistration,
                    isLoading: _isLoading,
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
