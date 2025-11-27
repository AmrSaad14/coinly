import 'package:coinly/core/di/injection_container.dart' as di;
import 'package:coinly/core/theme/app_colors.dart';
import 'package:coinly/core/utils/constants.dart';
import 'package:coinly/features/home/ui/widgets/kiosk_transactions_header.dart';
import 'package:coinly/features/home/ui/widgets/objectives_section_widget.dart';
import 'package:coinly/features/home/ui/widgets/performance_chart_widget.dart';
import 'package:coinly/features/kiosk/data/models/market_details_model.dart';
import 'package:coinly/features/kiosk/logic/market_cubit.dart';
import 'package:coinly/features/kiosk/logic/market_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KioskTransactionsScreen extends StatefulWidget {
  final int? marketId;

  const KioskTransactionsScreen({super.key, this.marketId});

  @override
  State<KioskTransactionsScreen> createState() =>
      _KioskTransactionsScreenState();
}

class _KioskTransactionsScreenState extends State<KioskTransactionsScreen> {
  late final MarketCubit _marketCubit;
  DateTime _selectedDate = DateTime.now();
  String _selectedMonth = '';

  // Arabic month names
  static const List<String> _arabicMonths = [
    'شهر يناير',
    'شهر فبراير',
    'شهر مارس',
    'شهر أبريل',
    'شهر مايو',
    'شهر يونيو',
    'شهر يوليو',
    'شهر أغسطس',
    'شهر سبتمبر',
    'شهر أكتوبر',
    'شهر نوفمبر',
    'شهر ديسمبر',
  ];

  @override
  void initState() {
    super.initState();
    _marketCubit = di.sl<MarketCubit>();
    _selectedMonth = _getArabicMonthName(_selectedDate);
    _loadMarketData();
  }

  String _getArabicMonthName(DateTime date) {
    return _arabicMonths[date.month - 1];
  }

  String _formatMonthForAPI(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _loadMarketData() async {
    if (widget.marketId == null) {
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString(AppConstants.accessToken);

      if (accessToken != null && accessToken.isNotEmpty) {
        final authorization = 'Bearer $accessToken';
        final monthString = _formatMonthForAPI(_selectedDate);

        _marketCubit.getMarketById(
          marketId: widget.marketId!,
          month: monthString,
          workerId: 1, // Default worker ID, can be changed later
          authorization: authorization,
        );
      }
    } catch (e) {
      print('❌ Error in _loadMarketData: $e');
    }
  }

  void _onMonthSelected(String monthName) {
    // Find the month index
    final monthIndex = _arabicMonths.indexOf(monthName);
    if (monthIndex != -1) {
      setState(() {
        _selectedMonth = monthName;
        _selectedDate = DateTime(_selectedDate.year, monthIndex + 1, 1);
      });
      _loadMarketData();
    }
  }

  List<WorkerPerformanceData> _buildWorkerPerformanceData(
    MarketDetailsModel market,
  ) {
    final workers = market.workersList;
    final chartData = market.chartData;

    if (workers.isEmpty) {
      return [];
    }

    // If we have chart data with 4 values, distribute them across workers
    // Otherwise, use available chart data or create default distribution
    List<int> periodValues;
    if (chartData.length >= 4) {
      periodValues = chartData.take(4).map((c) => c.value).toList();
    } else if (chartData.isNotEmpty) {
      // Pad with zeros if less than 4
      periodValues = [
        ...chartData.map((c) => c.value).toList(),
        ...List.filled(4 - chartData.length, 0),
      ];
    } else {
      // Default to zero if no chart data
      periodValues = [0, 0, 0, 0];
    }

    // Calculate total profit and dues per worker
    // Distribute based on number of active workers
    final activeWorkers = workers.where((w) => w.isActive).toList();
    final workerCount = activeWorkers.isNotEmpty
        ? activeWorkers.length
        : workers.length;

    final totalProfit = market.stats.totalProfit;
    final profitPerWorker = workerCount > 0
        ? (totalProfit / workerCount).round()
        : 0;

    final totalDues = market.stats.dueAmount;
    final duesPerWorker = workerCount > 0
        ? (totalDues / workerCount).round()
        : 0;

    // Calculate total earnings for each worker (sum of period values)
    final totalPeriodValue = periodValues.fold<int>(0, (sum, val) => sum + val);
    final earningsPerWorker = totalPeriodValue > 0 && workerCount > 0
        ? (totalPeriodValue / workerCount).round()
        : 0;

    // Create worker performance data
    // Each worker gets the same period distribution (chartData represents market-wide periods)
    // TODO: If API provides per-worker period data, update this to use individual worker data
    return (activeWorkers.isNotEmpty ? activeWorkers : workers).map((worker) {
      return WorkerPerformanceData(
        name: worker.name,
        periodData: List.from(
          periodValues,
        ), // Period data from chartData (1-7, 8-15, 16-25, 26-40)
        totalEarnings: earningsPerWorker > 0
            ? earningsPerWorker
            : profitPerWorker,
        totalDues: duesPerWorker,
      );
    }).toList();
  }

  List<ObjectiveCard> _buildObjectivesFromGoals(MarketDetailsModel market) {
    final workers = market.workersList;
    final goals = market.goals;

    // Debug: Print goals count
    print('📊 Building objectives from ${goals.length} goals');

    if (goals.isEmpty) {
      print('⚠️ No goals found in market data');
      return [];
    }

    return goals.map((goal) {
      final isCompleted = goal.target > 0 && goal.progress >= goal.target;

      // Find worker name by worker_id if available, otherwise use workerName from goal
      String workerName = goal.workerName ?? '';

      // Try to find worker by ID
      if (workerName.isEmpty && goal.workerId != null && workers.isNotEmpty) {
        try {
          final worker = workers.firstWhere((w) => w.id == goal.workerId);
          workerName = worker.name;
        } catch (e) {
          print('⚠️ Worker with ID ${goal.workerId} not found in workers list');
          // Worker not found, try using goal title
          workerName = goal.title.isNotEmpty ? goal.title : '';
        }
      }

      // If still no worker name, use goal title or default
      if (workerName.isEmpty) {
        workerName = goal.title.isNotEmpty ? goal.title : 'هدف غير محدد';
      }

      print(
        '✅ Mapping goal: worker=$workerName, progress=${goal.progress}, target=${goal.target}',
      );

      return ObjectiveCard(
        points: '${goal.progress} نقطه',
        name: workerName,
        status: isCompleted ? 'مستكمل' : 'غير مستكمل',
        target: 'الهدف : ${goal.target} نقطه',
        date: '', // Goals might not have dates in the API
        isCompleted: isCompleted,
      );
    }).toList();
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
            return Scaffold(
              appBar: AppBar(
                title: const Text('معاملات الكشك'),
                centerTitle: true,
                backgroundColor: AppColors.primary500,
                foregroundColor: AppColors.white,
              ),
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
                onPressed: _loadMarketData,
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
      final market = state.market;
      final workerPerformanceData = _buildWorkerPerformanceData(market);
      final objectives = _buildObjectivesFromGoals(market);

      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with total points and month selector
            KioskTransactionsHeader(
              totalPoints: market.stats.totalBalance,
              selectedMonth: _selectedMonth,
              onMonthSelected: _onMonthSelected,
            ),
            // Performance Chart Section - Shows each worker's performance across periods
            if (workerPerformanceData.isNotEmpty)
              PerformanceChartWidget(workersData: workerPerformanceData)
            else
              Padding(
                padding: EdgeInsets.all(20.w),
                child: Center(
                  child: Text(
                    'لا توجد بيانات عمال',
                    style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
                  ),
                ),
              ),
            // Objectives Section
            ObjectivesSectionWidget(
              objectives: objectives,
              onViewAll: () {
                // TODO: Navigate to all objectives screen
              },
            ),
            SizedBox(height: 20.h),
          ],
        ),
      );
    }

    // Initial state
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
    return const Center(child: CircularProgressIndicator());
  }
}
