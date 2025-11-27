import 'package:coinly/core/theme/app_assets.dart';
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
          icon: AppAssets.instaPay,
          label: 'انستاباي',
          isSelected: selectedMethod == 'انستاباي',
          onTap: () {
            onMethodChanged('انستاباي');
          },
        ),
        const SizedBox(height: 12),
        PaymentMethodOption(
          icon: AppAssets.vodafoneCash,
          label: 'فودافون كاش',
          isSelected: selectedMethod == 'فودافون كاش',
          onTap: () {
            onMethodChanged('فودافون كاش');
          },
        ),
        const SizedBox(height: 12),
        PaymentMethodOption(
          icon: AppAssets.orangeCash,
          label: 'اورانج كاش',
          isSelected: selectedMethod == 'اورانج كاش',
          onTap: () {
            onMethodChanged('اورانج كاش');
          },
        ),
        const SizedBox(height: 12),
        PaymentMethodOption(
          icon: AppAssets.eCash,
          label: 'اتصالات كاش',
          isSelected: selectedMethod == 'اتصالات كاش',
          onTap: () {
            onMethodChanged('اتصالات كاش');
          },
        ),
      ],
    );
  }
}
