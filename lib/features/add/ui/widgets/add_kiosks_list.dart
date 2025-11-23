import 'package:coinly/core/di/injection_container.dart' as di;
import 'package:coinly/core/router/app_router.dart';
import 'package:coinly/core/utils/constants.dart';
import 'package:coinly/features/kiosk/logic/markets_cubit.dart';
import 'package:coinly/features/kiosk/logic/markets_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddKiosksList extends StatefulWidget {
  const AddKiosksList({super.key});

  @override
  State<AddKiosksList> createState() => _AddKiosksListState();
}

class _AddKiosksListState extends State<AddKiosksList> {
  late final MarketsCubit _marketsCubit;

  @override
  void initState() {
    super.initState();
    _marketsCubit = di.sl<MarketsCubit>();
    _loadMarkets();
  }

  Future<void> _loadMarkets() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString(AppConstants.accessToken);

      if (accessToken != null && accessToken.isNotEmpty) {
        final authorization = 'Bearer $accessToken';
        _marketsCubit.getOwnerMarkets(authorization);
      }
    } catch (e) {
      print('❌ Error loading markets: $e');
    }
  }

  @override
  void dispose() {
    _marketsCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _marketsCubit,
      child: BlocBuilder<MarketsCubit, MarketsState>(
        builder: (context, state) {
          return Column(
            children: [
              // Markets List
              _buildMarketsList(state),

              const SizedBox(height: 12),

              // اضافة كشك - Outlined Button with Plus
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton.icon(
                  onPressed: () {
                    AppRouter.pushNamed(context, AppRouter.createKiosk);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF757575),
                    side: const BorderSide(
                      color: Color(0xFFBDBDBD),
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.add_circle_outline, size: 22),
                  label: const Text(
                    'اضافة كشك',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMarketsList(MarketsState state) {
    if (state is MarketsLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (state is MarketsError) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        child: Center(
          child: Column(
            children: [
              Text(
                'خطأ: ${state.message}',
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _loadMarkets,
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        ),
      );
    }

    if (state is MarketsLoaded) {
      if (state.markets.isEmpty) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 24.0),
          child: Center(
            child: Text(
              'لا توجد أكشاك متاحة',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: state.markets.length,
        itemBuilder: (context, index) {
          final market = state.markets[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () {
                  AppRouter.pushNamed(context, AppRouter.addWorkerInfo);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2A9578),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(Icons.store, size: 22),
                label: Text(
                  market.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

    // Initial state
    return const SizedBox.shrink();
  }
}
