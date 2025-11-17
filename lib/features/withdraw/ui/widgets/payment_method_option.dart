import 'package:flutter/material.dart';

class PaymentMethodOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentMethodOption({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF2A9578) : const Color(0xFFE0E0E0),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? Colors.black87 : const Color(0xFF757575),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFF2A9578) : const Color(0xFFBDBDBD),
                  width: 2,
                ),
                color: isSelected ? const Color(0xFF2A9578) : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.circle,
                      size: 12,
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

