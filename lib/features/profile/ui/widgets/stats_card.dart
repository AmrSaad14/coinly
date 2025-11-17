import 'package:flutter/material.dart';

class StatsCard extends StatelessWidget {
  final int employeeCount;
  final double totalSales;
  final double balance;

  const StatsCard({
    super.key,
    required this.employeeCount,
    required this.totalSales,
    required this.balance,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF0D7C66),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('الموظفين', employeeCount.toString()),
          _buildDivider(),
          _buildStatItem('إجمالي المبيعات', _formatNumber(totalSales)),
          _buildDivider(),
          _buildStatItem('الرصيد', _formatNumber(balance)),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 40,
      color: Colors.white24,
    );
  }

  String _formatNumber(double number) {
    return number.toStringAsFixed(1).replaceAll('.', ',');
  }
}

