import 'package:coinly/core/di/injection_container.dart' as di;
import 'package:coinly/features/home/logic/home_cubit.dart';
import 'package:coinly/features/home/logic/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/withdraw_header.dart';
import '../widgets/balance_display.dart';
import '../widgets/withdraw_form.dart';

class WithDrawScreen extends StatefulWidget {
  const WithDrawScreen({super.key, this.marketId});

  final int? marketId;

  @override
  State<WithDrawScreen> createState() => _WithDrawScreenState();
}

class _WithDrawScreenState extends State<WithDrawScreen> {
  late final HomeCubit _homeCubit;

  @override
  void initState() {
    super.initState();
    _homeCubit = di.sl<HomeCubit>();
    _homeCubit.loadHome();
  }

  @override
  void dispose() {
    _homeCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _homeCubit,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: SafeArea(
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              final currentBalance =
                  state is HomeLoaded ? state.ownerData.points : 0;

              return SingleChildScrollView(
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
                      BalanceDisplay(
                        currentBalance: currentBalance,
                        pointValue: 100,
                        coinValue: 10,
                      ),
                      const SizedBox(height: 32),
                      WithdrawForm(
                        marketId: widget.marketId,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
