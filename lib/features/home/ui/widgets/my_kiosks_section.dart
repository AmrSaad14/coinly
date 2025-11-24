import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/utils/constants.dart';
import '../../data/models/owner_data_model.dart';
import '../../../kiosk/logic/markets_cubit.dart';
import '../../../kiosk/logic/markets_state.dart';
import 'kiosk_card.dart';

class MyKiosksSection extends StatefulWidget {
  final OwnerDataModel? ownerData;

  const MyKiosksSection({super.key, this.ownerData});

  @override
  State<MyKiosksSection> createState() => _MyKiosksSectionState();
}

class _MyKiosksSectionState extends State<MyKiosksSection> {
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
      
      print('🔑 Access token from storage: ${accessToken != null ? (accessToken.length > 30 ? accessToken.substring(0, 30) + '...' : accessToken) : 'null'}');
      
      if (accessToken != null && accessToken.isNotEmpty) {
        final authorization = 'Bearer $accessToken';
        print('📤 Calling getOwnerMarkets with authorization');
        _marketsCubit.getOwnerMarkets(authorization);
      } else {
        print('❌ No access token found in storage');
        // You might want to emit an error state here
      }
    } catch (e, stackTrace) {
      print('❌ Error in _loadMarkets: $e');
      print('❌ Stack trace: $stackTrace');
    }
  }

  @override
  void dispose() {
    _marketsCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If ownerData is provided and has markets, use them directly
    if (widget.ownerData != null && widget.ownerData!.markets.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 4, bottom: 12, top: 12),
            child: Text(
              'الأكشاك الخاصة بي',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          SizedBox(
            height: 190.h,
            child: _buildMarketsFromOwnerData(),
          ),
        ],
      );
    }

    // Otherwise, use the existing API call approach
    return BlocProvider.value(
      value: _marketsCubit,
      child: BlocBuilder<MarketsCubit, MarketsState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 4, bottom: 12, top: 12),
                child: Text(
                  'الأكشاك الخاصة بي',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),

              // Horizontal ListView for Kiosk Cards
              SizedBox(
                height: 190.h,
                child: _buildMarketsList(state),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMarketsFromOwnerData() {
    if (widget.ownerData == null || widget.ownerData!.markets.isEmpty) {
      return const Center(
        child: Text(
          'لا توجد أكشاك متاحة',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      reverse: true, // RTL support
      itemCount: widget.ownerData!.markets.length,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      itemBuilder: (context, index) {
        final market = widget.ownerData!.markets[index];
        return Padding(
          padding: const EdgeInsets.only(left: 12),
          child: SizedBox(
            width: 350,
            child: KioskCard(
              name: market.name,
              balance: '${market.marketPoints} ج.م',
              debt: '${market.marketLoans} ج.م',
              marketId: market.id,
            ),
          ),
        );
      },
    );
  }

  Widget _buildMarketsList(MarketsState state) {
    if (state is MarketsLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state is MarketsError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
      );
    }

    if (state is MarketsLoaded) {
      if (state.markets.isEmpty) {
        return const Center(
          child: Text(
            'لا توجد أكشاك متاحة',
            style: TextStyle(color: Colors.grey),
          ),
        );
      }

      return ListView.builder(
        scrollDirection: Axis.horizontal,
        reverse: true, // RTL support
        itemCount: state.markets.length,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemBuilder: (context, index) {
          final market = state.markets[index];
          return Padding(
            padding: const EdgeInsets.only(left: 12),
            child: SizedBox(
              width: 350,
              child: KioskCard(
                name: market.name,
                balance: '0 ج.م', // TODO: Update with actual balance from API
                debt: '0 ج.م', // TODO: Update with actual debt from API
                marketId: market.id,
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
