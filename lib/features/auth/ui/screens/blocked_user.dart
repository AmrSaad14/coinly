import 'package:coinly/core/theme/app_colors.dart';
import 'package:coinly/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class BlockedUserScreen extends StatelessWidget {
  const BlockedUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset('assets/images/blocked.svg'),
        Text(
          'User Blocked',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.error500,
          ),
        ),
        Text(
          'Your account has been blocked.',
          style: TextStyle(fontSize: 16, color: AppColors.error500),
        ),
        Text(
          'If you think this is a mistake, please contact support.',
          style: TextStyle(fontSize: 16, color: AppColors.error500),
        ),
        CustomButton(
          text: 'Contact Support',
          onTap: () {
            launchUrl(Uri.parse('https://wa.me/+201158883085'));
          },
        ),
      ],
    );
  }
}
