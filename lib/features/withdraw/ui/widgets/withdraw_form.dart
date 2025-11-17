import 'package:flutter/material.dart';
import 'custom_text_field.dart';
import 'payment_method_selector.dart';
import 'withdraw_button.dart';
import '../screens/withdraw_confirmation_screen.dart';

class WithdrawForm extends StatefulWidget {
  const WithdrawForm({super.key});

  @override
  State<WithdrawForm> createState() => _WithdrawFormState();
}

class _WithdrawFormState extends State<WithdrawForm> {
  final TextEditingController _kioskNumberController = TextEditingController();
  final TextEditingController _pointsController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _selectedPaymentMethod = 'انستاباي';

  @override
  void dispose() {
    _kioskNumberController.dispose();
    _pointsController.dispose();
    super.dispose();
  }

  void _handleConfirm() {
    if (_formKey.currentState!.validate()) {
      final points = int.parse(_pointsController.text);
      final fees = (points * 0.1).round(); // 10% fee

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WithdrawConfirmationScreen(
            phoneNumber: _kioskNumberController.text,
            pointsToWithdraw: points,
            fees: fees,
            paymentMethod: _selectedPaymentMethod,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextField(
              controller: _kioskNumberController,
              label: 'اكتب رقم الكشك',
              placeholder: '010*******',
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال رقم الكشك';
                }
                if (value.length < 11) {
                  return 'رقم الكشك غير صحيح';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _pointsController,
              label: 'النقاط المراد سحبها',
              placeholder: '25675',
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال عدد النقاط';
                }
                final points = int.tryParse(value);
                if (points == null || points <= 0) {
                  return 'الرجاء إدخال عدد نقاط صحيح';
                }
                if (points > 3569) {
                  // Max balance
                  return 'الرصيد غير كافي';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'اختار وسيلة السحب',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            PaymentMethodSelector(
              selectedMethod: _selectedPaymentMethod,
              onMethodChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value;
                });
              },
            ),
            const SizedBox(height: 32),
            WithdrawButton(label: 'تأكيد', onPressed: _handleConfirm),
          ],
        ),
      ),
    );
  }
}
