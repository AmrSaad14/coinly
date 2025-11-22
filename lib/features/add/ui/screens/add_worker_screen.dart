import 'package:coinly/features/add/ui/widgets/add_kiosks_list.dart';
import 'package:coinly/features/add/ui/widgets/add_screen_body.dart';
import 'package:coinly/features/add/ui/widgets/add_screen_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddWorkerScreen extends StatelessWidget {
  const AddWorkerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AddScreenHeader(),
              SizedBox(height: 70.h),
              AddScreenBody(),
              SizedBox(height: 24.h),
              AddKiosksList(),
            ],
          ),
        ),
      ),
    );
  }
}
