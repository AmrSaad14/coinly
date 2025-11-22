import 'package:coinly/core/theme/app_colors.dart';
import 'package:coinly/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ManageKioskTotalPoints extends StatelessWidget {
  final int totalPoints;
  final int totalEarnings;
  final int totalDues;
  final VoidCallback? onViewTransactions;

  const ManageKioskTotalPoints({
    super.key,
    this.totalPoints = 3700,
    this.totalEarnings = 3700,
    this.totalDues = 3700,
    this.onViewTransactions,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.neutral100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
        ),
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              'إجمالي نقاطي',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textMedium,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            // Points Value
            Text(
              '$totalPoints نقطة',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primary500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            // Semi-circular Arc
            SizedBox(height: 200.h, child: _buildSemiCircularArc()),
            // Data Rows
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Total Earnings
                _buildDataRow(
                  label: 'إجمالي الأرباح',
                  value: '$totalEarnings نقطة',
                  color: AppColors.primary200,
                ),
                // Total Dues
                _buildDataRow(
                  label: 'إجمالي المستحقات',
                  value: '$totalDues نقطة',
                  color: AppColors.primary500,
                ),
              ],
            ),
            SizedBox(height: 24.h),
            // View Transactions Button
            CustomButton(
              width: double.infinity,
              onTap: () {},
              text: 'عرض المعاملات',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataRow({
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 8.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textMedium,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSemiCircularArc() {
    final total = totalEarnings + totalDues;
    final duesRatio = total > 0 ? totalDues / total : 0.5;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Full semi-circle background (earnings - light mint green)
        CircularPercentIndicator(
          radius: 100.r,
          lineWidth: 16.0,
          percent: 1.0,
          arcType: ArcType.HALF,
          arcBackgroundColor: Colors.transparent,
          progressColor: AppColors.primary500,
          startAngle: 180,
          circularStrokeCap: CircularStrokeCap.round,
        ),
        // Dues segment (dark teal) - left side
        // Note: This creates the left portion by using reverse direction
        CircularPercentIndicator(
          radius: 100.r,
          lineWidth: 16.0,
          percent: duesRatio,
          arcType: ArcType.HALF,
          arcBackgroundColor: Colors.transparent,
          progressColor: AppColors.primary200,
          startAngle: 180,
          circularStrokeCap: CircularStrokeCap.round,
          reverse: true,
        ),
      ],
    );
  }
}
