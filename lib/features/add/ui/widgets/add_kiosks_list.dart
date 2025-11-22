import 'package:coinly/core/router/app_router.dart';
import 'package:flutter/material.dart';

class AddKiosksList extends StatelessWidget {
  const AddKiosksList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            onPressed: () {
              AppRouter.pushNamed(context, AppRouter.addWorkerInfo);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2A9578),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            icon: const Icon(Icons.store, size: 22),
            label: const Text(
              'كشف النصر',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // كشف النور - Outlined Button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton.icon(
            onPressed: () {
              // TODO: Navigate to add worker for "كشف النور"
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF2A9578),
              side: const BorderSide(color: Color(0xFF2A9578), width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.store, size: 22),
            label: const Text(
              'كشف النور',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // اضافة كشك - Outlined Button with Plus
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton.icon(
            onPressed: () {
              AppRouter.pushNamed(context, AppRouter.createKiosk);
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF757575),
              side: const BorderSide(color: Color(0xFFBDBDBD), width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.add_circle_outline, size: 22),
            label: const Text(
              'اضافة كشك',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}
