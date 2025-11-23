import 'package:flutter/material.dart';
import 'package:coinly/core/di/injection_container.dart' as di;
import 'package:coinly/core/network/api_service.dart';
import 'package:coinly/core/router/app_router.dart';
import 'package:coinly/core/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile_menu_item.dart';

class ProfileMenuList extends StatelessWidget {
  const ProfileMenuList({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    try {
      // Get access token from SharedPreferences
      final prefs = di.sl<SharedPreferences>();
      final accessToken = prefs.getString(AppConstants.accessToken);

      if (accessToken != null && accessToken.isNotEmpty) {
        // Call logout API
        final apiService = di.sl<ApiService>();
        await apiService.logout('Bearer $accessToken');
      }

      // Clear stored data
      await prefs.remove(AppConstants.accessToken);
      await prefs.remove(AppConstants.cachedUser);

      // Navigate to login screen
      if (context.mounted) {
        AppRouter.pushNamedAndRemoveUntil(context, AppRouter.login);
      }
    } catch (e) {
      // Even if logout API fails, clear local data and navigate to login
      final prefs = di.sl<SharedPreferences>();
      await prefs.remove(AppConstants.accessToken);
      await prefs.remove(AppConstants.cachedUser);

      if (context.mounted) {
        AppRouter.pushNamedAndRemoveUntil(context, AppRouter.login);
      }
    }
  }

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
            _handleLogout(context);
          },
        ),
      ],
    );
  }
}
