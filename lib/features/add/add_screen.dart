import 'package:flutter/material.dart';

class AddScreen extends StatelessWidget {
  const AddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(height: 40),
              const Text(
                'إضافة جديد',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'اختر ما تريد إضافته',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 40),
              
              // Add Kiosk Card
              _buildAddCard(
                context: context,
                icon: Icons.store_outlined,
                title: 'إضافة كشك',
                subtitle: 'أضف كشك جديد لإدارته',
                onTap: () {
                  Navigator.pushNamed(context, '/create-kiosk');
                },
              ),
              
              const SizedBox(height: 16),
              
              // Add Store Card
              _buildAddCard(
                context: context,
                icon: Icons.business_outlined,
                title: 'إضافة متجر',
                subtitle: 'أضف متجر جديد لإدارته',
                onTap: () {
                  Navigator.pushNamed(context, '/create-store');
                },
              ),
              
              const SizedBox(height: 16),
              
              // Add Worker Card
              _buildAddCard(
                context: context,
                icon: Icons.person_add_outlined,
                title: 'إضافة عامل',
                subtitle: 'أضف عامل جديد للفريق',
                onTap: () {
                  // TODO: Navigate to add worker screen
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Color(0xFF2A9578),
            ),
            const Spacer(),
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFFD1EEE5),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF2A9578),
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}



