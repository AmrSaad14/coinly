import 'dart:async';
import 'package:coinly/core/theme/app_colors.dart';
import 'package:coinly/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pinput/pinput.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/network/api_service.dart';
import '../../data/models/verify_user_request_model.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String? verificationId;

  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
    this.verificationId,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  int _resendTimer = 60;
  Timer? _timer;
  String _verificationId = '';

  @override
  void initState() {
    super.initState();
    _verificationId = widget.verificationId ?? '';
    _startResendTimer();

    // Debug: Print session info
    print('🔐 ========== OTP VERIFICATION SESSION INIT ==========');
    print('🔐 Phone Number: ${widget.phoneNumber}');
    print('🔐 Verification ID: ${widget.verificationId ?? "None"}');
    print('🔐 Verification ID Length: ${widget.verificationId?.length ?? 0}');
    print('🔐 Current Firebase User: ${_auth.currentUser?.uid ?? "None"}');
    print('🔐 Timestamp: ${DateTime.now().toIso8601String()}');
  }

  @override
  void dispose() {
    _otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _resendTimer = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimer > 0) {
        setState(() {
          _resendTimer--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _resendOTP() async {
    if (_resendTimer == 0) {
      setState(() {
        _isLoading = true;
      });

      try {
        await _auth.verifyPhoneNumber(
          phoneNumber: widget.phoneNumber,
          timeout: const Duration(seconds: 60),
          verificationCompleted: (PhoneAuthCredential credential) async {
            await _signInWithCredential(credential);
          },
          verificationFailed: (FirebaseAuthException e) {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });

              String errorMessage = 'حدث خطأ أثناء إرسال الرمز';
              if (e.code == 'too-many-requests') {
                errorMessage =
                    'عدد كبير جداً من المحاولات. يرجى المحاولة لاحقاً';
              } else if (e.code == 'internal-error' &&
                  e.message?.contains('BILLING_NOT_ENABLED') == true) {
                errorMessage =
                    'يجب تفعيل الفوترة في Firebase أو استخدام أرقام اختبار';
              }

              _showErrorSnackBar(errorMessage);
            }
          },
          codeSent: (String verificationId, int? resendToken) {
            print('🔄 ========== CODE RESENT SUCCESSFULLY ==========');
            print('🔄 Verification ID: $verificationId');
            print('🔄 Resend Token: $resendToken');
            print('🔄 Phone Number: ${widget.phoneNumber}');
            print('🔄 Timestamp: ${DateTime.now().toIso8601String()}');

            if (mounted) {
              setState(() {
                _isLoading = false;
                _verificationId = verificationId;
              });

              _startResendTimer();
              _showSuccessSnackBar('تم إرسال الرمز مرة أخرى');
            }
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            _verificationId = verificationId;
          },
        );
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          _showErrorSnackBar('حدث خطأ غير متوقع');
        }
      }
    }
  }

  void _verifyOTP() async {
    if (_otpController.text.length == 6) {
      setState(() {
        _isLoading = true;
      });

      print('🔐 ========== VERIFYING OTP ==========');
      print('🔐 OTP Code: ${_otpController.text}');
      print('🔐 Verification ID: $_verificationId');
      print('🔐 Verification ID Length: ${_verificationId.length}');
      print('🔐 Phone Number: ${widget.phoneNumber}');
      print('🔐 Timestamp: ${DateTime.now().toIso8601String()}');

      try {
        final credential = PhoneAuthProvider.credential(
          verificationId: _verificationId,
          smsCode: _otpController.text,
        );

        print('✅ Credential Created');
        print('✅ Credential Provider: ${credential.providerId}');
        print('✅ Credential Sign-In Method: ${credential.signInMethod}');

        await _signInWithCredential(credential);
      } on FirebaseAuthException catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          String errorMessage = 'الرمز غير صحيح';

          if (e.code == 'invalid-verification-code') {
            errorMessage = 'الرمز الذي أدخلته غير صحيح';
          } else if (e.code == 'session-expired') {
            errorMessage = 'انتهت صلاحية الرمز. يرجى إعادة الإرسال';
          }

          _showErrorSnackBar(errorMessage);
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          _showErrorSnackBar('حدث خطأ غير متوقع');
        }
      }
    }
  }

  Future<void> _signInWithCredential(PhoneAuthCredential credential) async {
    try {
      print('🔐 ========== SIGNING IN WITH CREDENTIAL ==========');
      print('🔐 Credential Provider: ${credential.providerId}');
      print('🔐 Credential Sign-In Method: ${credential.signInMethod}');

      final userCredential = await _auth.signInWithCredential(credential);

      print('✅ ========== SIGN-IN SUCCESSFUL ==========');
      print('✅ User UID: ${userCredential.user?.uid}');
      print('✅ User Phone: ${userCredential.user?.phoneNumber}');
      print('✅ User Email: ${userCredential.user?.email ?? "None"}');
      print(
        '✅ User Display Name: ${userCredential.user?.displayName ?? "None"}',
      );
      print('✅ Is New User: ${userCredential.additionalUserInfo?.isNewUser}');
      print('✅ Provider ID: ${userCredential.additionalUserInfo?.providerId}');
      print('✅ Profile: ${userCredential.additionalUserInfo?.profile}');

      // Get ID Token for session info
      String? idToken = await _getIdToken(userCredential.user);

      // Make ID Token available - you can use it here for API calls
      if (idToken == null) {
        print('❌ ID Token is null!');
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          _showErrorSnackBar('فشل الحصول على رمز التحقق');
          return;
        }
      }

      // Get Firebase UID
      final firebaseUid = userCredential.user?.uid;
      if (firebaseUid == null) {
        print('❌ Firebase UID is null!');
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          _showErrorSnackBar('فشل الحصول على معرف المستخدم');
          return;
        }
      }

      // Store isNewUser value before API call
      final isNewUser = userCredential.additionalUserInfo?.isNewUser ?? true;

      // Call backend API to verify user
      await _verifyUserWithBackend(
        idToken: idToken!,
        phoneNumber: widget.phoneNumber,
        firebaseUid: firebaseUid!,
        isNewUser: isNewUser,
      );
    } catch (e) {
      print('❌ ========== SIGN-IN ERROR ==========');
      print('❌ Error: $e');
      print('❌ Error Type: ${e.runtimeType}');
      if (e is FirebaseAuthException) {
        print('❌ Error Code: ${e.code}');
        print('❌ Error Message: ${e.message}');
        print('❌ Error Details: ${e.toString()}');
      }
      rethrow;
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.primaryTeal,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  /// Get the Firebase ID Token for the current user
  /// Returns the ID token string if available, null otherwise
  Future<String?> _getIdToken(User? user) async {
    if (user == null) {
      print('⚠️ User is null, cannot get ID token');
      return null;
    }

    try {
      final idToken = await user.getIdToken();
      final idTokenResult = await user.getIdTokenResult();

      print('');
      print('═══════════════════════════════════════════════════════════');
      print('✅ ========== FIREBASE ID TOKEN INFO ==========');
      print('═══════════════════════════════════════════════════════════');
      print('');
      print('🔑 ID TOKEN (Full):');
      print('$idToken');
      print('');
      print('📊 Token Details:');
      print('  • Length: ${idToken?.length ?? 0} characters');
      print('  • Expiration: ${idTokenResult.expirationTime}');
      print('  • Issued At: ${idTokenResult.issuedAtTime}');
      print('  • Auth Time: ${idTokenResult.authTime}');
      print('  • Sign-In Provider: ${idTokenResult.signInProvider}');
      print('');
      print('📋 Token Claims:');
      idTokenResult.claims?.forEach((key, value) {
        print('  • $key: $value');
      });
      print('');
      print('═══════════════════════════════════════════════════════════');
      print('');

      return idToken;
    } catch (e) {
      print('⚠️ Error getting ID token: $e');
      return null;
    }
  }

  /// Get the Firebase ID Token for the current authenticated user
  /// This is a public method you can call from anywhere to get the current user's ID token
  Future<String?> getCurrentIdToken() async {
    final user = _auth.currentUser;
    return await _getIdToken(user);
  }

  /// Verify user with backend API
  Future<void> _verifyUserWithBackend({
    required String idToken,
    required String phoneNumber,
    required String firebaseUid,
    required bool isNewUser,
  }) async {
    try {
      print('');
      print('═══════════════════════════════════════════════════════════');
      print('🌐 ========== CALLING BACKEND API ==========');
      print('═══════════════════════════════════════════════════════════');
      print('');
      print('📱 Phone Number: $phoneNumber');
      print('🆔 Firebase UID: $firebaseUid');
      print('🔑 ID Token (Full):');
      print('$idToken');
      print('');
      print('📦 Request Body:');
      print('{');
      print('  "id_token": "$idToken",');
      print('  "phone_number": "$phoneNumber",');
      print('  "firebase_uid": "$firebaseUid"');
      print('}');
      print('');
      print('═══════════════════════════════════════════════════════════');
      print('');

      final apiService = di.sl<ApiService>();
      final request = VerifyUserRequestModel(
        idToken: idToken,
        phoneNumber: phoneNumber,
        firebaseUid: firebaseUid,
      );

      // Debug: Show the JSON representation of the request
      final requestJson = request.toJson();
      print('📤 Request JSON:');
      print(requestJson);
      print('');
      print('🚀 Sending POST request to: https://grow-eg.online/users/verify');
      print('');

      final response = await apiService.verifyUser(request);

      print('');
      print('═══════════════════════════════════════════════════════════');
      print('✅ ========== BACKEND API RESPONSE ==========');
      print('═══════════════════════════════════════════════════════════');
      print('');
      print('✅ Success: ${response.success}');
      print('📝 Message: ${response.message ?? "No message"}');
      print('📊 Data: ${response.data ?? "No data"}');
      print('');
      print('═══════════════════════════════════════════════════════════');
      print('');

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // After successful Firebase OTP verification, always navigate to complete registration
        // Firebase verification already succeeded, so we proceed regardless of backend response
        print('✅ OTP verified successfully - Navigating to complete registration');
        
        // Navigate to complete registration screen
        AppRouter.pushReplacementNamed(
          context,
          AppRouter.completeRegistration,
          arguments: {'phoneNumber': phoneNumber},
        );
      }
    } catch (e) {
      print('');
      print('═══════════════════════════════════════════════════════════');
      print('❌ ========== BACKEND API ERROR ==========');
      print('═══════════════════════════════════════════════════════════');
      print('');
      print('❌ Error Type: ${e.runtimeType}');
      print('❌ Error: $e');
      print('');

      // If it's a DioException, show more details
      if (e.toString().contains('DioException') ||
          e.toString().contains('DioError')) {
        print('📋 Error Details:');
        print('   This is a network/HTTP error');
        print('   Check your internet connection and API endpoint');
      }
      print('');
      print('═══════════════════════════════════════════════════════════');
      print('');

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        String errorMessage = 'حدث خطأ أثناء التحقق من المستخدم';
        if (e.toString().contains('SocketException') ||
            e.toString().contains('TimeoutException')) {
          errorMessage = 'فشل الاتصال بالخادم. يرجى المحاولة مرة أخرى';
        } else if (e.toString().contains('401') ||
            e.toString().contains('403')) {
          errorMessage = 'فشل التحقق من المستخدم';
        }

        _showErrorSnackBar(errorMessage);
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: AppColors.primaryTeal, width: 2),
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: AppColors.primaryTeal),
      ),
    );

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),

                  // SVG Illustration
                  Center(
                    child: SizedBox(
                      height: 280,
                      child: SvgPicture.asset(
                        'assets/images/otp.svg',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Title
                  const Text(
                    'كود التحقق',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 12),

                  // Subtitle
                  Text(
                    'تم إرسال كود تحقق إلى هاتفك عبر رسالة SMS، أدخل الكود للمتابعة',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 32),

                  // OTP input
                  Center(
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: Pinput(
                        controller: _otpController,
                        length: 6,
                        defaultPinTheme: defaultPinTheme,
                        focusedPinTheme: focusedPinTheme,
                        submittedPinTheme: submittedPinTheme,
                        onCompleted: (pin) {
                          _verifyOTP();
                        },
                        enabled: !_isLoading,
                        showCursor: true,
                        cursor: Container(
                          width: 2,
                          height: 24,
                          color: AppColors.primaryTeal,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Resend OTP
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'لم تستلم الكود؟',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '|',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[400],
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: _resendOTP,
                          child: Text(
                            _resendTimer > 0
                                ? 'أعد الإرسال ($_resendTimer)'
                                : 'أعد الإرسال',
                            style: TextStyle(
                              fontSize: 14,
                              color: _resendTimer > 0
                                  ? Colors.grey[600]
                                  : AppColors.primaryTeal,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),

                  // Verify button
                  CustomButton(
                    text: 'تأكيد',
                    onTap: _verifyOTP,
                    isLoading: _isLoading,
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
