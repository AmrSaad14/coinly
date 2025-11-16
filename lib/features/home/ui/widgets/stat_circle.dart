import 'package:flutter/material.dart';

class StatCircle extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const StatCircle({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: const BoxDecoration(
            color: Color(0xFFD1EEE5),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: const Color(0xFF2A9578), size: 32),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF2A9578),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

