import 'dart:async';
import 'package:coinly/core/theme/app_colors.dart';
import 'package:coinly/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pinput/pinput.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/router/app_router.dart';

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

      try {
        final credential = PhoneAuthProvider.credential(
          verificationId: _verificationId,
          smsCode: _otpController.text,
        );

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
      final userCredential = await _auth.signInWithCredential(credential);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // Check if this is a new user
        if (userCredential.additionalUserInfo?.isNewUser ?? true) {
          // Navigate to complete registration screen
          AppRouter.pushReplacementNamed(
            context,
            AppRouter.completeRegistration,
            arguments: {'phoneNumber': widget.phoneNumber},
          );
        } else {
          // Existing user, navigate to home
          AppRouter.pushNamedAndRemoveUntil(context, AppRouter.home);
        }
      }
    } catch (e) {
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
