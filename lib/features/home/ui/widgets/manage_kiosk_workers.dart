import 'package:coinly/core/theme/app_assets.dart';
import 'package:coinly/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:coinly/features/kiosk/data/models/market_details_model.dart';

class ManageKioskWorkers extends StatelessWidget {
  final List<MarketWorkerModel> workers;

  const ManageKioskWorkers({super.key, this.workers = const []});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
          color: AppColors.neutral100,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          primary: false,
          itemBuilder: (context, index) {
            if (workers.isEmpty) {
              return ListTile(
                title: Text(
                  'لا يوجد عمال مسجلين',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }

            final worker = workers[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.primary500,
                radius: 24,
              ),
              title: Text(worker.name.isNotEmpty ? worker.name : 'عامل'),
              subtitle: Text(worker.isActive ? 'نشط' : 'غير نشط'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                      color: AppColors.primary500,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      worker.isActive ? 'نشط' : 'غير نشط',
                      style: TextStyle(
                        color: AppColors.neutral100,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(width: 24.w),
                  InkWell(
                    onTap: () {},
                    child: SvgPicture.asset(AppAssets.deleteIcon),
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) {
            return SizedBox(height: 10.h);
          },
          itemCount: workers.isEmpty ? 1 : workers.length,
        ),
      ),
    );
  }
}
