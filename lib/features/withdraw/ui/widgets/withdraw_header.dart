import 'package:flutter/material.dart';

class WithdrawHeader extends StatelessWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const WithdrawHeader({
    super.key,
    this.title = 'سحب',
    this.showBackButton = false,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(width: 40), // Spacer for alignment
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                iconSize: 20,
                color: Colors.black87,
                onPressed: onBackPressed ?? () => Navigator.pop(context),
              )
            : const SizedBox(width: 40), // Spacer for alignment
      ],
    );
  }
}

