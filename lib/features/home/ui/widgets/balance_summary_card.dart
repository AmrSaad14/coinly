import 'package:flutter/material.dart';
import 'stat_circle.dart';

class BalanceSummaryCard extends StatelessWidget {
  const BalanceSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text(
            'إجمالي رصيدي',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 20),

          // Three Stat Circles
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              StatCircle(
                icon: Icons.money_off_outlined,
                label: 'الديون',
                value: '25 نقطة',
              ),
              StatCircle(
                icon: Icons.show_chart,
                label: 'الإيرادات',
                value: '253 نقطة',
              ),
              StatCircle(
                icon: Icons.people_alt_outlined,
                label: 'عدد العمال',
                value: '253 عامل',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
