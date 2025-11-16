import 'dart:async';
import 'package:coinly/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pinput/pinput.dart';
import '../../core/router/app_router.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpVerificationScreen({super.key, required this.phoneNumber});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  int _resendTimer = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
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

  void _resendOTP() {
    if (_resendTimer == 0) {
      // TODO: Implement resend OTP logic
      _startResendTimer();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم إرسال الرمز مرة أخرى'),
          backgroundColor: AppColors.primaryTeal,
        ),
      );
    }
  }

  void _verifyOTP() async {
    if (_otpController.text.length == 6) {
      setState(() {
        _isLoading = true;
      });

      // TODO: Implement Firebase OTP verification
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // Navigate to complete registration screen
        AppRouter.pushReplacementNamed(
          context,
          AppRouter.completeRegistration,
          arguments: {'phoneNumber': widget.phoneNumber},
        );
      }
    }
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
                  SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _verifyOTP,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryTeal,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                        disabledBackgroundColor: AppColors.primaryTeal
                            .withOpacity(0.6),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text(
                              'تأكيد',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
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
