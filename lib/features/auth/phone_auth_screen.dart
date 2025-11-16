import 'package:coinly/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../core/router/app_router.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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

      // TODO: Implement Firebase phone authentication
      // For now, we'll navigate to OTP screen
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        AppRouter.pushNamed(
          context,
          AppRouter.otpVerification,
          arguments: {
            'phoneNumber': _completePhoneNumber,
          },
        );
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
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
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
                        labelStyle: const TextStyle(
                          color: Colors.grey,
                        ),
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
                      onCountryChanged: (country) {
                        // Update complete phone number when country changes
                        if (_phoneController.text.isNotEmpty) {
                          _completePhoneNumber = '+${country.dialCode}${_phoneController.text}';
                        }
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

