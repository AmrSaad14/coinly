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
      final dio = di.sl<Dio>();
      print('🔵 Calling login API...');

      // Get raw response to see all data
      Response<dynamic>? rawResponse;
      try {
        rawResponse = await dio.post<dynamic>(
          '/oauth/token',
          data: loginRequest.toJson(),
        );

        print('═══════════════════════════════════════════════════════');
        print('📦 RAW LOGIN API RESPONSE');
        print('═══════════════════════════════════════════════════════');
        print('   Status Code: ${rawResponse.statusCode}');
        print('   Status Message: ${rawResponse.statusMessage}');
        print('   Headers: ${rawResponse.headers.map}');
        print('   Data Type: ${rawResponse.data.runtimeType}');
        print('   ───────────────────────────────────────────────────');

        if (rawResponse.data is Map) {
          final dataMap = rawResponse.data as Map;
          print('   📋 ALL RESPONSE FIELDS:');
          print('   ───────────────────────────────────────────────────');
          dataMap.forEach((key, value) {
            if (value is Map) {
              print('   • $key: [Map with ${value.length} keys]');
              print('      Keys: ${value.keys.toList()}');
              value.forEach((subKey, subValue) {
                final subValueStr = subValue?.toString() ?? 'null';
                final preview = subValueStr.length > 50
                    ? '${subValueStr.substring(0, 50)}...'
                    : subValueStr;
                print('      - $subKey: $preview (${subValue.runtimeType})');
              });
            } else {
              final valueStr = value?.toString() ?? 'null';
              final preview = valueStr.length > 50
                  ? '${valueStr.substring(0, 50)}...'
                  : valueStr;
              print('   • $key: $preview (${value.runtimeType})');
            }
          });
          print('   ───────────────────────────────────────────────────');
          print('   Total fields: ${dataMap.length}');
          print('   Field names: ${dataMap.keys.toList()}');
        } else if (rawResponse.data is List) {
          print('   ⚠️ Response is a List, not a Map');
          print('   Data: ${rawResponse.data}');
        } else {
          print('   ⚠️ Response is neither Map nor List');
          print('   Data: ${rawResponse.data}');
        }
        print('═══════════════════════════════════════════════════════');
      } catch (e) {
        print('❌ Failed to get raw response: $e');
        if (e is DioException && e.response != null) {
          print('   Error Status: ${e.response?.statusCode}');
          print('   Error Data: ${e.response?.data}');
          
          // Handle 403 error - navigate to owner access screen
          if (e.response?.statusCode == 403) {
            if (mounted) {
              AppRouter.pushNamed(context, AppRouter.ownerAccess);
            }
            setState(() {
              _isLoading = false;
            });
            return; // Exit early, don't continue with login
          }
        }
        // Continue - let outer catch block handle other errors
      }

      // Parse response with API service
      print('🔵 Parsing response with API service...');
      final response = await apiService.login(loginRequest);

      print('═══════════════════════════════════════════════════════');
      print('📋 PARSED LOGIN RESPONSE MODEL');
      print('═══════════════════════════════════════════════════════');
      print('   Access Token: ${response.accessToken ?? 'null'}');
      if (response.accessToken != null) {
        print('   Access Token Length: ${response.accessToken!.length}');
        print(
          '   Access Token Preview: ${response.accessToken!.substring(0, response.accessToken!.length > 30 ? 30 : response.accessToken!.length)}...',
        );
      }
      print('   Token Type: ${response.tokenType ?? 'null'}');
      print('   Expires In: ${response.expiresIn ?? 'null'}');
      print('   Refresh Token: ${response.refreshToken ?? 'null'}');
      if (response.refreshToken != null) {
        print('   Refresh Token Length: ${response.refreshToken!.length}');
      }
      print('   Scope: ${response.scope ?? 'null'}');
      print('   ───────────────────────────────────────────────────');
      print('   Full JSON: ${response.toJson()}');
      print('═══════════════════════════════════════════════════════');

      // Compare raw vs parsed and check for user data
      if (rawResponse?.data is Map) {
        final rawMap = rawResponse!.data as Map;
        print('═══════════════════════════════════════════════════════');
        print('🔍 COMPARING RAW vs PARSED:');
        print('═══════════════════════════════════════════════════════');
        print('   Raw has access_token: ${rawMap.containsKey('access_token')}');
        print('   Raw access_token value: ${rawMap['access_token']}');
        print('   Parsed accessToken: ${response.accessToken}');
        print('   Match: ${rawMap['access_token'] == response.accessToken}');
        print('   ───────────────────────────────────────────────────');

        // Check for user-related fields
        print('   👤 CHECKING FOR USER DATA FIELDS:');
        final userFields = [
          'user',
          'user_data',
          'userData',
          'profile',
          'user_info',
          'userInfo',
          'account',
          'data',
        ];
        bool foundUserData = false;
        for (var field in userFields) {
          if (rawMap.containsKey(field)) {
            foundUserData = true;
            print('   ✅ Found field: $field');
            print('      Type: ${rawMap[field].runtimeType}');
            if (rawMap[field] is Map) {
              final userMap = rawMap[field] as Map;
              print('      User data fields: ${userMap.keys.toList()}');
              userMap.forEach((key, value) {
                print('         • $key: $value');
              });
            } else {
              print('      Value: ${rawMap[field]}');
            }
          }
        }
        if (!foundUserData) {
          print('   ⚠️ No user data fields found in response');
        }

        // List all fields that aren't in the model
        print('   ───────────────────────────────────────────────────');
        print('   📊 FIELDS NOT IN MODEL:');
        final modelFields = [
          'access_token',
          'token_type',
          'expires_in',
          'refresh_token',
          'scope',
        ];
        final extraFields = rawMap.keys
            .where((key) => !modelFields.contains(key.toString()))
            .toList();
        if (extraFields.isNotEmpty) {
          for (var field in extraFields) {
            print(
              '   • $field: ${rawMap[field]} (${rawMap[field].runtimeType})',
            );
          }
        } else {
          print('   ✅ All fields are in the model');
        }
        print('═══════════════════════════════════════════════════════');
      }

      // Extract token from raw response if parsed response has null
      String? accessToken = response.accessToken;

      if ((accessToken == null || accessToken.isEmpty) &&
          rawResponse?.data is Map) {
        final rawMap = rawResponse!.data as Map;
        print('⚠️ Parsed token is null, extracting from raw response...');

        // Try top-level fields first
        accessToken =
            rawMap['access_token'] as String? ??
            rawMap['accessToken'] as String? ??
            rawMap['token'] as String? ??
            rawMap['auth_token'] as String?;

        // If not found, check inside 'user' object
        if ((accessToken == null || accessToken.isEmpty) &&
            rawMap['user'] is Map) {
          final userMap = rawMap['user'] as Map;
          print('   Checking inside "user" object...');
          print('   User keys: ${userMap.keys.toList()}');
          accessToken =
              userMap['access_token'] as String? ??
              userMap['accessToken'] as String? ??
              userMap['token'] as String? ??
              userMap['auth_token'] as String?;
        }

        // If still not found, check inside 'meta' object
        if ((accessToken == null || accessToken.isEmpty) &&
            rawMap['meta'] is Map) {
          final metaMap = rawMap['meta'] as Map;
          print('   Checking inside "meta" object...');
          print('   Meta keys: ${metaMap.keys.toList()}');
          accessToken =
              metaMap['access_token'] as String? ??
              metaMap['accessToken'] as String? ??
              metaMap['token'] as String? ??
              metaMap['auth_token'] as String?;
        }

        if (accessToken != null && accessToken.isNotEmpty) {
          print(
            '✅ Found token in raw response: ${accessToken.substring(0, accessToken.length > 30 ? 30 : accessToken.length)}...',
          );
        } else {
          print('❌ Token not found in raw response');
          print('   Available top-level keys: ${rawMap.keys.toList()}');
          if (rawMap['user'] is Map) {
            print(
              '   User object keys: ${(rawMap['user'] as Map).keys.toList()}',
            );
          }
          if (rawMap['meta'] is Map) {
            print(
              '   Meta object keys: ${(rawMap['meta'] as Map).keys.toList()}',
            );
          }
        }
      }

      // Store access token
      final prefs = di.sl<SharedPreferences>();
      if (accessToken != null && accessToken.isNotEmpty) {
        await prefs.setString(AppConstants.accessToken, accessToken);
        print('✅ Access token saved to SharedPreferences');
        print(
          '   Token source: ${response.accessToken != null ? 'parsed' : 'raw response'}',
        );

        // Verify storage
        final savedToken = prefs.getString(AppConstants.accessToken);
        print('   Saved token length: ${savedToken?.length ?? 0}');
        print('   Token match: ${savedToken == accessToken}');
      } else {
        print('❌ ERROR: Access token is null or empty!');
        print('   Parsed token: ${response.accessToken}');
        if (rawResponse?.data is Map) {
          final rawMap = rawResponse!.data as Map;
          print('   Raw response keys: ${rawMap.keys.toList()}');
          print('   Raw access_token: ${rawMap['access_token']}');
        }
        print('   Cannot save token to SharedPreferences');
        throw Exception('Access token not received from server');
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
                // Navigate to owner access screen on 403 error
                if (mounted) {
                  AppRouter.pushNamed(context, AppRouter.ownerAccess);
                }
                return; // Exit early, don't show error message
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
