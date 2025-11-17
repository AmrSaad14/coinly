import 'package:flutter/material.dart';

class ProfileInfoCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String location;
  final VoidCallback? onEditPressed;

  const ProfileInfoCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.location,
    this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[300],
              ),
              child: ClipOval(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.grey[600],
                    );
                  },
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: onEditPressed,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Color(0xFF0D7C66),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          name,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          location,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

