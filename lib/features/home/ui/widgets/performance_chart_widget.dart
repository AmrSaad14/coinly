import 'package:coinly/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';

/// Data model for a worker's performance across different time periods
class WorkerPerformanceData {
  final String name;
  final List<int> periodData; // [1-7, 8-15, 16-25, 26-40]
  final int totalEarnings;
  final int totalDues;

  WorkerPerformanceData({
    required this.name,
    required this.periodData,
    required this.totalEarnings,
    required this.totalDues,
  });
}

class PerformanceChartWidget extends StatefulWidget {
  /// List of workers with their performance data
  /// Each worker has their own performance across 4 periods
  final List<WorkerPerformanceData> workersData;

  const PerformanceChartWidget({super.key, this.workersData = const []});

  @override
  State<PerformanceChartWidget> createState() => _PerformanceChartWidgetState();
}

class _PerformanceChartWidgetState extends State<PerformanceChartWidget> {
  int _selectedIndex = 4; // Default to محمد (last worker)

  List<WorkerPerformanceData> get _defaultWorkersData {
    if (widget.workersData.isNotEmpty) return widget.workersData;

    return [
      WorkerPerformanceData(
        name: 'عمر',
        periodData: [800, 1500, 1200, 1800],
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
  }

  @override
  Widget build(BuildContext context) {
    final workers = _defaultWorkersData;
    if (workers.isEmpty) {
      return const SizedBox.shrink();
    }

    // Ensure selected index is valid
    if (_selectedIndex >= workers.length) {
      _selectedIndex = 0;
    }

    final selectedWorker = workers[_selectedIndex];
    final data = selectedWorker.periodData;
    final maxValue = 4000;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.neutral100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Name Selector - Switch between workers
          SizedBox(
            height: 32.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: workers.length,
              itemBuilder: (context, index) {
                final isSelected = index == _selectedIndex;
                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 12.w),
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isSelected
                              ? AppColors.primary500
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Text(
                      workers[index].name,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: isSelected
                            ? AppColors.primary500
                            : AppColors.textMedium,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16.h),
          // Bar Chart using fl_chart
          SizedBox(
            height: 220.h,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final barWidth = 50.w;
                return BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: maxValue.toDouble(),
                    minY: 0,
                    barTouchData: BarTouchData(enabled: false),
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final labels = ['1-7', '8-15', '16-25', '26-40'];
                            final index = value.toInt() - 1;
                            if (index >= 0 && index < labels.length) {
                              return Padding(
                                padding: EdgeInsets.only(top: 6.h),
                                child: Text(
                                  labels[index],
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: AppColors.textMedium,
                                  ),
                                ),
                              );
                            }
                            return const Text('');
                          },
                          reservedSize: 30.h,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 35.w,
                          getTitlesWidget: (value, meta) {
                            if (value % 1000 == 0) {
                              return Text(
                                value.toInt().toString(),
                                style: TextStyle(
                                  fontSize: 9.sp,
                                  color: AppColors.textMedium,
                                ),
                              );
                            }
                            return const Text('');
                          },
                        ),
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 1000,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: AppColors.neutral200.withValues(alpha: 0.3),
                          strokeWidth: 1,
                        );
                      },
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: [
                      BarChartGroupData(
                        x: 1,
                        barRods: [
                          BarChartRodData(
                            toY: data[0].toDouble(),
                            color: AppColors.primary600,
                            width: barWidth,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(4.r),
                            ),
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 2,
                        barRods: [
                          BarChartRodData(
                            toY: data[1].toDouble(),
                            color: AppColors.primary800,
                            width: barWidth,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(4.r),
                            ),
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 3,
                        barRods: [
                          BarChartRodData(
                            toY: data[2].toDouble(),
                            color: AppColors.primary600,
                            width: barWidth,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(4.r),
                            ),
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 4,
                        barRods: [
                          BarChartRodData(
                            toY: data[3].toDouble(),
                            color: AppColors.primary800,
                            width: barWidth,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(4.r),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 6.h),
          // X-axis label
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: Text(
                  'يوم',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textMedium,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Summary Boxes - Per worker
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSummaryBox('المستحقات', '${selectedWorker.totalDues} نقطه'),
              _buildSummaryBox(
                'اجمالي الأرباح',
                '${selectedWorker.totalEarnings} نقطه',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryBox(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textMedium,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primary500,
            ),
          ),
        ],
      ),
    );
  }
}
