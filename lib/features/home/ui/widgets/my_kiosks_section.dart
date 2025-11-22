import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'kiosk_card.dart';

class MyKiosksSection extends StatelessWidget {
  const MyKiosksSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 4, bottom: 12, top: 12),
          child: Text(
            'الأكشاك الخاصة بي',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),

        // Horizontal ListView for Kiosk Cards
        SizedBox(
          height: 190.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            reverse: true, // RTL support
            itemCount: 10, // Number of kiosks
            padding: const EdgeInsets.symmetric(horizontal: 4),
            itemBuilder: (context, index) {
              return const Padding(
                padding: EdgeInsets.only(left: 12),
                child: SizedBox(
                  width: 350,
                  child: KioskCard(
                    name: 'كشك البحر',
                    balance: '3700 ج.م',
                    debt: '9 ج.م',
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
