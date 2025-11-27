import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/owner_data_model.dart';
import 'kiosk_card.dart';

class MyKiosksSection extends StatelessWidget {
  final OwnerDataModel? ownerData;

  const MyKiosksSection({super.key, this.ownerData});

  @override
  Widget build(BuildContext context) {
    if (ownerData == null || ownerData!.markets.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: const [
          Padding(
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
          Center(
            child: Text(
              'لا توجد أكشاك متاحة',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      );
    }

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
        SizedBox(height: 190.h, child: _buildMarketsFromOwnerData(context)),
      ],
    );
  }

  Widget _buildMarketsFromOwnerData(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      reverse: true, // RTL support
      itemCount: ownerData!.markets.length,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      itemBuilder: (context, index) {
        final market = ownerData!.markets[index];
        return Padding(
          padding: const EdgeInsets.only(left: 12),
          child: SizedBox(
            width: 350,
            child: KioskCard(
              name: market.name,
              balance: '${market.marketPoints} ج.م',
              debt: '${market.marketLoans} ج.م',
              marketId: market.id,
              onDeleted: (id) {
                // Actual delete logic is handled in HomeCubit via the parent
                // This widget stays as a pure UI renderer.
              },
            ),
          ),
        );
      },
    );
  }
}
