import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AddScreenBody extends StatelessWidget {
  const AddScreenBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(
          'assets/images/add_worker.svg',
          height: 200,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 24),
    
    // Description text
    const Text(
      'قم باختيار الكشك لاضافة عامل جديد',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 16,
        color: Color(0xFF757575),
        height: 1.5,
      ),
    ),
      ],
    );
  }
}