import 'package:flutter/material.dart';
import 'profile_menu_item.dart';

class ProfileMenuList extends StatelessWidget {
  const ProfileMenuList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileMenuItem(
          iconPath: 'assets/icons/profile.svg',
          title: 'الملف الشخصي',
          onTap: () {
            // Navigate to personal profile
          },
        ),
        const Divider(height: 1),
        ProfileMenuItem(
          iconPath: 'assets/icons/settings.svg',
          title: 'الإعدادات',
          onTap: () {
            // Navigate to settings
          },
        ),
        const Divider(height: 1),
        ProfileMenuItem(
          iconPath: 'assets/icons/error.svg',
          title: 'سياسة الخصوصية',
          onTap: () {
            // Navigate to privacy policy
          },
        ),
        const Divider(height: 1),
        ProfileMenuItem(
          iconPath: 'assets/icons/replace.svg',
          title: 'تبديل لحساب الموظف',
          onTap: () {
            // Switch to employee account
          },
        ),
        const Divider(height: 1),
        ProfileMenuItem(
          iconPath: 'assets/icons/logout.svg',
          color: Colors.red,
          title: 'تسجيل الخروج',
          isDestructive: true,
          onTap: () {
            // Handle logout
          },
        ),
      ],
    );
  }
}
