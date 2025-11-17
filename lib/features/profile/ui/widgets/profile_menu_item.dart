import 'package:coinly/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileMenuItem extends StatelessWidget {
  final String iconPath;
  final Color color;
  final String title;
  final VoidCallback? onTap;
  final bool isDestructive;

  const ProfileMenuItem({
    super.key,
    required this.iconPath,
    required this.title,
    this.onTap,
    this.isDestructive = false,
    this.color = AppColors.neutral600,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(Icons.chevron_left, size: 20, color: Colors.grey[400]),
            const SizedBox(width: 8),
            const Spacer(),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: isDestructive ? const Color(0xFFE74C3C) : Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 12),
            SvgPicture.asset(
              color: color,
              iconPath,
              width: 22,
              height: 22,
              colorFilter: ColorFilter.mode(
                isDestructive ? const Color(0xFFE74C3C) : Colors.grey[700]!,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
