import 'package:coinly/core/di/injection_container.dart' as di;
import 'package:coinly/core/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../logic/cubit/withdraw_cubit.dart';
import '../widgets/withdraw_header.dart';
import '../widgets/withdraw_button.dart';
import '../widgets/withdraw_details.dart';

class WithdrawConfirmationScreen extends StatefulWidget {
  const WithdrawConfirmationScreen({
    super.key,
    this.phoneNumber = '',
    this.pointsToWithdraw = 0,
    this.fees = 0,
    required this.paymentMethod,
    required this.paymentMethodIcon,
    required this.isTransfer,
    this.marketId,
  });

  final String phoneNumber;
  final int pointsToWithdraw;
  final int fees;
  final String paymentMethod;
  final String paymentMethodIcon;
  final bool isTransfer;
  final int? marketId;

  @override
  State<WithdrawConfirmationScreen> createState() =>
      _WithdrawConfirmationScreenState();
}

class _WithdrawConfirmationScreenState
    extends State<WithdrawConfirmationScreen> {
  late final TextEditingController _phoneController;
  late final TextEditingController _pointsController;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(
      text: widget.phoneNumber == 'غير متوفر' ? '' : widget.phoneNumber,
    );
    _pointsController = TextEditingController(
      text: widget.pointsToWithdraw > 0
          ? widget.pointsToWithdraw.toString()
          : '',
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _pointsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<WithdrawCubit>(),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          body: SafeArea(
            child: BlocConsumer<WithdrawCubit, WithdrawState>(
              listener: (context, state) {
                if (state is WithdrawError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else if (state is WithdrawSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: const Color(0xFF2A9578),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                  AppRouter.pushNamedAndRemoveUntil(context, AppRouter.home);
                } else if (state is TransactionSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: const Color(0xFF2A9578),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                  AppRouter.pushNamedAndRemoveUntil(context, AppRouter.home);
                }
              },
              builder: (context, state) {
                final isLoading =
                    state is WithdrawLoading || state is TransactionLoading;

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 16.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      WithdrawHeader(
                        title: 'تفاصيل التحويل',
                        showBackButton: true,
                        onBackPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(height: 32),
                      WithdrawDetails(
                        fees: widget.fees,
                        paymentMethod: widget.paymentMethod,
                        paymentMethodIcon: widget.paymentMethodIcon,
                        phoneController: _phoneController,
                        pointsController: _pointsController,
                        showPaymentMethodIcon: !widget.isTransfer,
                      ),
                      SizedBox(height: 48.h),
                      WithdrawButton(
                        label: 'تأكيد',
                        isLoading: isLoading,
                        onPressed: () => _onConfirmPressed(context),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _onConfirmPressed(BuildContext context) {
    final phone = _phoneController.text.trim();
    final rawPoints = _pointsController.text.trim();
    final points = int.tryParse(rawPoints.isEmpty ? '0' : rawPoints) ?? 0;

    // Basic validation before hitting the API
    if (points < 10 || points > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('مجموع النقاط يجب أن يكون بين 10 و 100'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى إدخال رقم الهاتف المرتبط بالحساب أو المحفظة'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final cubit = context.read<WithdrawCubit>();

    if (widget.isTransfer && widget.marketId != null) {
      cubit.createTransaction(
        points: points,
        clientPhoneNumber: phone,
        marketId: widget.marketId!,
      );
    } else {
      cubit.createWithdrawalRequest(
        points: points,
        phoneNumber: phone,
        method: widget.paymentMethod,
      );
    }
  }
}
