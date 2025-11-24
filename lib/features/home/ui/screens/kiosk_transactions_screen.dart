import 'package:coinly/core/theme/app_colors.dart';
import 'package:coinly/features/home/ui/widgets/kiosk_transactions_header.dart';
import 'package:coinly/features/home/ui/widgets/objectives_section_widget.dart';
import 'package:coinly/features/home/ui/widgets/performance_chart_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class KioskTransactionsScreen extends StatefulWidget {
  const KioskTransactionsScreen({super.key});

  @override
  State<KioskTransactionsScreen> createState() =>
      _KioskTransactionsScreenState();
}

class _KioskTransactionsScreenState extends State<KioskTransactionsScreen> {
  String _selectedMonth = 'شهر سبتمبر';

  // Each worker has their own performance data across 4 periods
  final List<WorkerPerformanceData> _workersPerformanceData = [
    WorkerPerformanceData(
      name: 'عمر',
      periodData: [800, 1500, 1200, 1800], // [1-7, 8-15, 16-25, 26-40]
      totalEarnings: 2800,
      totalDues: 2800,
    ),
    WorkerPerformanceData(
      name: 'مهند',
      periodData: [900, 2000, 1500, 2500],
      totalEarnings: 3200,
      totalDues: 3200,
    ),
    WorkerPerformanceData(
      name: 'أحمد',
      periodData: [1000, 2500, 1800, 3000],
      totalEarnings: 3800,
      totalDues: 3800,
    ),
    WorkerPerformanceData(
      name: 'يوسف',
      periodData: [950, 2200, 1600, 2800],
      totalEarnings: 3600,
      totalDues: 3600,
    ),
    WorkerPerformanceData(
      name: 'محمد',
      periodData: [1100, 3200, 2100, 4200],
      totalEarnings: 3700,
      totalDues: 3700,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('معاملات الكشك'),
          centerTitle: true,
          backgroundColor: AppColors.primary500,
          foregroundColor: AppColors.white,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with total points and month selector
              KioskTransactionsHeader(
                totalPoints: 3700,
                selectedMonth: _selectedMonth,
                onMonthSelected: (String month) {
                  setState(() {
                    _selectedMonth = month;
                  });
                  // TODO: Load data for selected month
                },
              ),
              // Performance Chart Section - Shows each worker's performance across periods
              PerformanceChartWidget(workersData: _workersPerformanceData),
              // Objectives Section
              ObjectivesSectionWidget(
                onViewAll: () {
                  // TODO: Navigate to all objectives screen
                },
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
