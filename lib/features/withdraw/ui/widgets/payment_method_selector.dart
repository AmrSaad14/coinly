import 'package:flutter/material.dart';
import 'payment_method_option.dart';

class PaymentMethodSelector extends StatelessWidget {
  final String selectedMethod;
  final ValueChanged<String> onMethodChanged;

  const PaymentMethodSelector({
    super.key,
    required this.selectedMethod,
    required this.onMethodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PaymentMethodOption(
          label: 'انستاباي',
          isSelected: selectedMethod == 'انستاباي',
          onTap: () => onMethodChanged('انستاباي'),
        ),
        const SizedBox(height: 12),
        PaymentMethodOption(
          label: 'فودافون كاش',
          isSelected: selectedMethod == 'فودافون كاش',
          onTap: () => onMethodChanged('فودافون كاش'),
        ),
      ],
    );
  }
}
