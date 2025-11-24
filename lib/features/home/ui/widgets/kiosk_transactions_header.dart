import 'package:coinly/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class KioskTransactionsHeader extends StatelessWidget {
  final int totalPoints;
  final String selectedMonth;
  final List<String> months;
  final Function(String)? onMonthSelected;

  const KioskTransactionsHeader({
    super.key,
    this.totalPoints = 3700,
    this.selectedMonth = 'شهر سبتمبر',
    this.months = const [
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
    ],
    this.onMonthSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Month Selector (Left)

          // Total Points (Right)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'اجمالي نقاطي',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textMedium,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                '$totalPoints نقطه',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary500,
                ),
              ),
            ],
          ),
          PopupMenuButton<String>(
            offset: Offset(0, 40.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.neutral100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.neutral200, width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    selectedMonth,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textDark,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 20.sp,
                    color: AppColors.textMedium,
                  ),
                ],
              ),
            ),
            itemBuilder: (BuildContext context) {
              return months.map((String month) {
                return PopupMenuItem<String>(
                  value: month,
                  child: Text(
                    month,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: month == selectedMonth
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: month == selectedMonth
                          ? AppColors.primary500
                          : AppColors.textDark,
                    ),
                  ),
                );
              }).toList();
            },
            onSelected: (String month) {
              if (onMonthSelected != null) {
                onMonthSelected!(month);
              }
            },
          ),
        ],
      ),
    );
  }
}
