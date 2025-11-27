import 'package:coinly/core/theme/app_assets.dart';
import 'package:coinly/core/theme/app_colors.dart';
import 'package:coinly/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'payment_method_selector.dart';
import 'withdraw_button.dart';
import '../screens/withdraw_confirmation_screen.dart';

class WithdrawForm extends StatefulWidget {
  const WithdrawForm({super.key, this.marketId});

  final int? marketId;

  @override
  State<WithdrawForm> createState() => _WithdrawFormState();
}

class _WithdrawFormState extends State<WithdrawForm> {
  final TextEditingController _kioskNumberController = TextEditingController();
  final TextEditingController _pointsController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _selectedPaymentMethod = 'انستاباي';
  String? _instapayChannel;

  static const Map<String, String> _paymentMethodIcons = {
    'انستاباي': AppAssets.instaPay,
    'فودافون كاش': AppAssets.vodafoneCash,
    'اورانج كاش': AppAssets.orangeCash,
    'اتصالات كاش': AppAssets.eCash,
  };

  @override
  void dispose() {
    _kioskNumberController.dispose();
    _pointsController.dispose();
    super.dispose();
  }

  Future<void> _handleConfirm() async {
    if (_selectedPaymentMethod == 'انستاباي' && _instapayChannel == null) {
      final selection = await _showInstapayChannelDialog();
      if (selection == null) {
        return;
      }
      if (!mounted) return;
      setState(() {
        _instapayChannel = selection;
      });
    }

    final icon =
        _paymentMethodIcons[_selectedPaymentMethod] ?? AppAssets.instaPay;
    _navigateToConfirmation(
      paymentMethod: _buildPaymentMethodLabel(_selectedPaymentMethod),
      paymentMethodIcon: icon,
      isTransfer: widget.marketId != null,
      marketId: widget.marketId,
    );
  }

  void _navigateToConfirmation({
    required String paymentMethod,
    required String paymentMethodIcon,
    required bool isTransfer,
    int? marketId,
  }) {
    final phoneNumber = _kioskNumberController.text.trim().isEmpty
        ? 'غير متوفر'
        : _kioskNumberController.text.trim();
    final rawPoints = _pointsController.text.trim();
    final points = int.tryParse(rawPoints.isEmpty ? '0' : rawPoints) ?? 0;
    final fees = (points * 0.1).round();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WithdrawConfirmationScreen(
          phoneNumber: phoneNumber,
          pointsToWithdraw: points,
          fees: fees,
          paymentMethod: paymentMethod,
          paymentMethodIcon: paymentMethodIcon,
          isTransfer: isTransfer,
          marketId: marketId,
        ),
      ),
    );
  }

  String _buildPaymentMethodLabel(String method) {
    if (method == 'انستاباي' && _instapayChannel != null) {
      return '$method - $_instapayChannel';
    }
    return method;
  }

  Future<String?> _showInstapayChannelDialog() {
    return showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Text('اختر نوع التحويل', textAlign: TextAlign.center),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomButton(
                  text: 'حساب بنكي',
                  width: double.infinity,
                  onTap: () {
                    Navigator.of(dialogContext).pop('حساب بنكي');
                  },
                ),
                const SizedBox(height: 12),
                CustomButton(
                  text: 'محفظة الكترونية',
                  width: double.infinity,
                  backgroundColor: Colors.white,
                  textColor: AppColors.primaryTeal,
                  borderColor: AppColors.primaryTeal,
                  onTap: () {
                    Navigator.of(dialogContext).pop('محفظة الكترونية');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
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
                  if (value != 'انستاباي') {
                    _instapayChannel = null;
                  }
                });
              },
            ),
            const SizedBox(height: 32),
            WithdrawButton(label: 'تأكيد', onPressed: () => _handleConfirm()),
          ],
        ),
      ),
    );
  }
}
