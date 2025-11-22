import 'package:coinly/core/router/app_router.dart';
import 'package:flutter/material.dart';

class AddScreenHeader extends StatelessWidget {
  const AddScreenHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(width: 40), // Spacer for alignment
        const Text(
          'اضافة عامل جديد',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          iconSize: 20,
          color: Colors.black87,
          onPressed: () {
            AppRouter.pop(context);
            // Back navigation (if needed)
          },
        ),
      ],
    );
  }
}
