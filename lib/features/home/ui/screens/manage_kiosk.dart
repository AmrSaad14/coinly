import 'package:coinly/features/home/ui/widgets/assign_widgets.dart';
import 'package:coinly/features/home/ui/widgets/manage_kiosk_total_points.dart';
import 'package:coinly/features/home/ui/widgets/manage_kiosk_workers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ManageKioskScreen extends StatelessWidget {
  const ManageKioskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text('ادارة الكشف النصر'), centerTitle: true),
        body: ListView(
          primary: true,
          shrinkWrap: true,
          children: [
            ManageKioskTotalPoints(),
            SizedBox(height: 20.h),
            AssignPointsWidget(),
            SizedBox(height: 20.h),
            ManageKioskWorkers(),
          ],
        ),
      ),
    );
  }
}
