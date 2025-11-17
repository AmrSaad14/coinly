import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'الملف الشخصي',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.grey[800],
        ),
      ),
    );
  }
}

