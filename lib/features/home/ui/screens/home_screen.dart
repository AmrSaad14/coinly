import 'package:flutter/material.dart';
import '../widgets/home_header.dart';
import '../widgets/add_worker_banner.dart';
import '../widgets/my_kiosks_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: const [
              // Header Section
              HomeHeader(),
              AddWorkerBanner(),
              MyKiosksSection(),

              // Body Content
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
