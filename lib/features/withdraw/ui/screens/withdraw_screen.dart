import 'package:flutter/material.dart';
import '../widgets/withdraw_header.dart';
import '../widgets/balance_display.dart';
import '../widgets/withdraw_form.dart';

class WithDrawScreen extends StatelessWidget {
  const WithDrawScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const WithdrawHeader(),
                const SizedBox(height: 32),
                const BalanceDisplay(
                  currentBalance: 3569,
                  pointValue: 100,
                  coinValue: 10,
                ),
                const SizedBox(height: 32),
                WithdrawForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
