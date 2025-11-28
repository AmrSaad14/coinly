import 'package:coinly/features/kiosk/create_kiosk_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../features/home/ui/screens/home_screen.dart';
import '../../features/add/ui/screens/add_worker_screen.dart';
import '../../features/profile/ui/screens/profile_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  // Start with Home (الرئيسية) - now at index 2 after removing سحب tab
  int _currentIndex = 2;

  // List of screens for each navigation tab (Reversed for RTL display)
  final List<Widget> _screens = const [
    ProfileScreen(), // Index 0 - الملف الشخصي (leftmost)
    CreatekioskScreen(), // Index 1 - اضافة
    HomeScreen(), // Index 2 - الرئيسية (rightmost)
  ];

  void _onNavigationIndexChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _buildNavIcon(String assetPath, bool isActive) {
    return SvgPicture.asset(
      assetPath,
      width: 24,
      height: 24,
      colorFilter: ColorFilter.mode(
        isActive ? const Color(0xFF2A9578) : const Color(0xFFBDBDBD),
        BlendMode.srcIn,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onNavigationIndexChanged,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF2A9578),
        unselectedItemColor: const Color(0xFFBDBDBD),
        selectedFontSize: 12,
        unselectedFontSize: 11,
        elevation: 8,
        items: [
          BottomNavigationBarItem(
            icon: _buildNavIcon('assets/icons/profile.svg', false),
            activeIcon: _buildNavIcon('assets/icons/profile.svg', true),
            label: 'الملف الشخصي',
          ),
          BottomNavigationBarItem(
            icon: _buildNavIcon('assets/icons/add.svg', false),
            activeIcon: _buildNavIcon('assets/icons/add.svg', true),
            label: 'اضافة',
          ),
          BottomNavigationBarItem(
            icon: _buildNavIcon('assets/icons/home.svg', false),
            activeIcon: _buildNavIcon('assets/icons/home.svg', true),
            label: 'الرئيسية',
          ),
        ],
      ),
    );
  }
}
