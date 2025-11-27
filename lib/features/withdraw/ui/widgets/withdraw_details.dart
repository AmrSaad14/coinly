import 'package:coinly/features/withdraw/ui/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class WithdrawDetails extends StatelessWidget {
  final int fees;
  final String paymentMethod;
  final String paymentMethodIcon;
  final TextEditingController phoneController;
  final TextEditingController pointsController;

  const WithdrawDetails({
    super.key,
    required this.fees,
    required this.paymentMethod,
    required this.paymentMethodIcon,
    required this.phoneController,
    required this.pointsController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 72,
          height: 72,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF6F9F8),
            shape: BoxShape.circle,
          ),
          child: Image.asset(paymentMethodIcon, fit: BoxFit.contain),
        ),
        const SizedBox(height: 12),
        Text(
          paymentMethod,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 24),
        CustomTextField(
          controller: phoneController,
          placeholder: 'ادخل رقم الهاتم المربوط بالحساب او المحفظة',
          label: 'رقم الهاتف',
        ),
        const SizedBox(height: 24),
        CustomTextField(
          controller: pointsController,
          placeholder: 'ادخل النقاط المراد تحويلها',
          label: ' النقاط المراد تحويلها',
        ),
      ],
    );
  }
}
