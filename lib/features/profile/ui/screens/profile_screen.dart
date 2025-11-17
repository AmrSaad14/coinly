import 'package:flutter/material.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_info_card.dart';
import '../widgets/stats_card.dart';
import '../widgets/profile_menu_list.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const ProfileHeader(),
              const SizedBox(height: 16),
              const ProfileInfoCard(
                imageUrl:
                    'https://example.com/profile.jpg', // Replace with actual image URL
                name: 'أحمد يوسف',
                location: 'المنصورة، مصر',
              ),
              const StatsCard(
                employeeCount: 900,
                totalSales: 1000.0,
                balance: 1000.0,
              ),
              const SizedBox(height: 8),
              const ProfileMenuList(),
            ],
          ),
        ),
      ),
    );
  }
}
