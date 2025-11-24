import 'package:coinly/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ObjectiveCard {
  final String points;
  final String name;
  final String status;
  final String target;
  final String date;
  final bool isCompleted;
  final bool isRefund;
  final String? source;

  ObjectiveCard({
    required this.points,
    required this.name,
    required this.status,
    required this.target,
    required this.date,
    this.isCompleted = false,
    this.isRefund = false,
    this.source,
  });
}

class ObjectivesSectionWidget extends StatelessWidget {
  final List<ObjectiveCard> objectives;
  final VoidCallback? onViewAll;

  const ObjectivesSectionWidget({
    super.key,
    this.objectives = const [],
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final defaultObjectives = objectives.isEmpty
        ? [
            ObjectiveCard(
              points: '19 نقطه',
              name: 'يوسف احمد',
              status: 'غير مستكمل',
              target: 'الهدف : 19 نقطه',
              date: '5 سبتمبر',
              isCompleted: false,
            ),
            ObjectiveCard(
              points: '20 نقطه',
              name: 'محمد ابراهيم',
              status: 'مستكمل',
              target: 'الهدف : 20 نقطه',
              date: '7 سبتمبر',
              isCompleted: true,
            ),
            ObjectiveCard(
              points: '3700 ج.م',
              name: 'يوسف احمد',
              status: 'استرجاع',
              target: 'من المالك',
              date: '10 صباحا, 5 سبتمبر',
              isRefund: true,
            ),
          ]
        : objectives;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'الأهداف',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              InkWell(
                onTap: onViewAll,
                child: Text(
                  'عرض الكل',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Objective Cards
          ...defaultObjectives.map(
            (objective) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: _ObjectiveCardWidget(objective: objective),
            ),
          ),
        ],
      ),
    );
  }
}

class _ObjectiveCardWidget extends StatelessWidget {
  final ObjectiveCard objective;

  const _ObjectiveCardWidget({required this.objective});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.neutral100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
      ),
      child: Row(
        children: [
          // Left side - Status and Details (swapped from right)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (objective.isRefund)
                      Icon(
                        Icons.refresh,
                        size: 20.sp,
                        color: AppColors.primaryTeal,
                      )
                    else
                      Icon(
                        objective.isCompleted
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        size: 16.sp,
                        color: objective.isCompleted
                            ? AppColors.primary500
                            : AppColors.error500,
                      ),
                    SizedBox(width: 4.w),
                    Text(
                      objective.status,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: objective.isCompleted || objective.isRefund
                            ? AppColors.primary500
                            : AppColors.error500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  objective.target,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textMedium,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  objective.date,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textLight,
                  ),
                ),
              ],
            ),
          ),
          // Right side - Points and Name (swapped from left)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  objective.points,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  objective.name,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textMedium,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
