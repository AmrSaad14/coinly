import 'package:coinly/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/router/app_router.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _completePhoneNumber = '';
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _sendOTP() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Debug: Print the phone number being sent
      print('Sending OTP to: $_completePhoneNumber');

      try {
        await _auth.verifyPhoneNumber(
          phoneNumber: _completePhoneNumber,
          timeout: const Duration(seconds: 60),
          verificationCompleted: (PhoneAuthCredential credential) async {
            // Auto-verification completed (Android only)
            try {
              await _auth.signInWithCredential(credential);
              if (mounted) {
                setState(() {
                  _isLoading = false;
                });
                // Check if user needs to complete registration
                _checkUserRegistration();
              }
            } catch (e) {
              if (mounted) {
                setState(() {
                  _isLoading = false;
                });
                _showErrorSnackBar('حدث خطأ في التحقق التلقائي');
              }
            }
          },
          verificationFailed: (FirebaseAuthException e) {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });

              String errorMessage = 'حدث خطأ أثناء إرسال الرمز';

              if (e.code == 'invalid-phone-number') {
                errorMessage =
                    'رقم الهاتف غير صحيح. تأكد من إدخال الرقم بشكل صحيح';
              } else if (e.code == 'too-many-requests') {
                errorMessage =
                    'عدد كبير جداً من المحاولات. يرجى المحاولة لاحقاً';
              } else if (e.code == 'network-request-failed') {
                errorMessage = 'تحقق من اتصالك بالإنترنت';
              } else if (e.code == 'internal-error') {
                if (e.message?.contains('BILLING_NOT_ENABLED') == true) {
                  errorMessage =
                      'يجب تفعيل الفوترة في Firebase أو استخدام أرقام اختبار';
                } else if (e.message?.contains('reCAPTCHA') == true ||
                    e.message?.contains('Recaptcha') == true) {
                  errorMessage =
                      'خطأ في إعداد reCAPTCHA. يرجى الاتصال بالدعم الفني';
                }
              }

              // Debug: Print error details
              print('Firebase Auth Error: ${e.code} - ${e.message}');

              _showErrorSnackBar(errorMessage);
            }
          },
          codeSent: (String verificationId, int? resendToken) {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });

              AppRouter.pushNamed(
                context,
                AppRouter.otpVerification,
                arguments: {
                  'phoneNumber': _completePhoneNumber,
                  'verificationId': verificationId,
                },
              );
            }
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            // Auto-retrieval timeout callback
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

  void _checkUserRegistration() {
    final user = _auth.currentUser;
    if (user != null) {
      // Check if user has completed registration
      // For now, we'll navigate to complete registration
      // You can add Firestore check here to see if user profile exists
      AppRouter.pushReplacementNamed(
        context,
        AppRouter.completeRegistration,
        arguments: {'phoneNumber': _completePhoneNumber},
      );
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
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),

                  // Title
                  const Text(
                    'تسجيل الدخول',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 12),

                  // Subtitle
                  Text(
                    'أدخل رقم هاتفك للمتابعة',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 40),

                  // Phone number field
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: IntlPhoneField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: 'رقم الهاتف',
                        labelStyle: const TextStyle(color: Colors.grey),
                        alignLabelWithHint: true,
                        floatingLabelAlignment: FloatingLabelAlignment.start,
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
                          borderSide: const BorderSide(
                            color: AppColors.primaryTeal,
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      initialCountryCode: 'EG',
                      languageCode: 'ar',
                      onChanged: (phone) {
                        _completePhoneNumber = phone.completeNumber;
                      },
                      validator: (value) {
                        if (value == null || value.number.isEmpty) {
                          return 'الرجاء إدخال رقم الهاتف';
                        }
                        if (value.number.length < 9) {
                          return 'رقم الهاتف غير صحيح';
                        }
                        return null;
                      },
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Submit button
                  SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _sendOTP,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryTeal,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
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
                              'إرسال الرمز',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),

                  const Spacer(),

                  // Terms and conditions
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'بالمتابعة، أنت توافق على الشروط والأحكام وسياسة الخصوصية',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
