import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/owner_data_model.dart';
import 'stat_circle.dart';

class BalanceSummaryCard extends StatelessWidget {
  final OwnerDataModel? ownerData;

  const BalanceSummaryCard({super.key, this.ownerData});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'إجمالي نقاطي',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 20),

          // Three Stat Circles
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              StatCircle(
                icon: Icons.money_off_outlined,
                label: 'الديون',
                value: '${ownerData?.loans ?? 0} نقطة',
              ),
              StatCircle(
                icon: Icons.show_chart,
                label: 'الإيرادات',
                value: '${ownerData?.profits ?? 0} نقطة',
              ),
              StatCircle(
                icon: Icons.people_alt_outlined,
                label: 'العمال',
                value: '${ownerData?.workersCount ?? 0} عامل',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
