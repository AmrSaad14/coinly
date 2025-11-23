import 'package:coinly/core/di/injection_container.dart' as di;
import 'package:coinly/core/utils/constants.dart';
import 'package:coinly/features/home/ui/widgets/assign_widgets.dart';
import 'package:coinly/features/home/ui/widgets/manage_kiosk_total_points.dart';
import 'package:coinly/features/home/ui/widgets/manage_kiosk_workers.dart';
import 'package:coinly/features/kiosk/logic/market_cubit.dart';
import 'package:coinly/features/kiosk/logic/market_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManageKioskScreen extends StatefulWidget {
  final int? marketId;

  const ManageKioskScreen({super.key, this.marketId});

  @override
  State<ManageKioskScreen> createState() => _ManageKioskScreenState();
}

class _ManageKioskScreenState extends State<ManageKioskScreen> {
  late final MarketCubit _marketCubit;

  @override
  void initState() {
    super.initState();
    _marketCubit = di.sl<MarketCubit>();
    _loadMarket();
  }

  Future<void> _loadMarket() async {
    if (widget.marketId == null) {
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString(AppConstants.accessToken);

      if (accessToken != null && accessToken.isNotEmpty) {
        final authorization = 'Bearer $accessToken';
        _marketCubit.getMarketById(widget.marketId!, authorization);
      }
    } catch (e) {
      print('❌ Error in _loadMarket: $e');
    }
  }

  @override
  void dispose() {
    _marketCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider.value(
        value: _marketCubit,
        child: BlocBuilder<MarketCubit, MarketState>(
          builder: (context, state) {
            // Determine AppBar title based on state
            String appBarTitle = 'ادارة الكشف';
            if (state is MarketLoaded) {
              appBarTitle = state.market.name.isNotEmpty
                  ? 'ادارة ${state.market.name}'
                  : 'ادارة الكشك';
            }

            return Scaffold(
              appBar: AppBar(title: Text(appBarTitle), centerTitle: true),
              body: _buildBody(state),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(MarketState state) {
    if (state is MarketLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is MarketError) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64.sp, color: Colors.red),
              SizedBox(height: 16.h),
              Text(
                'حدث خطأ',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                state.message,
                style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
              ElevatedButton(
                onPressed: _loadMarket,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: 32.w,
                    vertical: 12.h,
                  ),
                ),
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        ),
      );
    }

    if (state is MarketLoaded) {
      return ListView(
        primary: true,
        shrinkWrap: true,
        children: [
          ManageKioskTotalPoints(
            totalPoints: state.market.marketPoints,
            totalEarnings: state.market.marketPoints,
            totalDues: state.market.marketLoans,
          ),
          SizedBox(height: 20.h),
          AssignPointsWidget(),
          SizedBox(height: 20.h),
          ManageKioskWorkers(),
        ],
      );
    }

    // Initial state or no market ID
    if (widget.marketId == null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.info_outline, size: 64.sp, color: Colors.grey[400]),
              SizedBox(height: 16.h),
              Text(
                'لا يوجد كشف محدد',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Loading or initial state with market ID
    return ListView(
      primary: true,
      shrinkWrap: true,
      children: [
        ManageKioskTotalPoints(),
        SizedBox(height: 20.h),
        AssignPointsWidget(),
        SizedBox(height: 20.h),
        ManageKioskWorkers(),
      ],
    );
  }
}
