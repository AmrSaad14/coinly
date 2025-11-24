import 'package:flutter/material.dart';

import 'package:coinly/core/theme/app_colors.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixIconWidget,
    this.suffixIconWidget,
    this.obscureText = false,
    this.enabled = true,
    this.showVisibilityToggle = false,
    this.visibilityToggleOnPrefix = false,
    this.readOnly = false,
    this.onTap,
  });

  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Widget? prefixIconWidget;
  final Widget? suffixIconWidget;
  final bool obscureText;
  final bool enabled;
  final bool showVisibilityToggle;
  final bool visibilityToggleOnPrefix;
  final bool readOnly;
  final VoidCallback? onTap;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  void didUpdateWidget(covariant CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.obscureText != widget.obscureText) {
      _obscureText = widget.obscureText;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      validator: widget.validator,
      onChanged: widget.onChanged,
      obscureText: widget.showVisibilityToggle
          ? _obscureText
          : widget.obscureText,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      onTap: widget.onTap,
      decoration: InputDecoration(
        hintText: widget.hint,
        hintTextDirection: TextDirection.rtl,
        hintStyle: const TextStyle(color: AppColors.neutral400),
        filled: true,
        fillColor: AppColors.neutral100,
        prefixIcon:
            widget.showVisibilityToggle && widget.visibilityToggleOnPrefix
            ? _buildVisibilityToggle()
            : widget.prefixIconWidget ?? _buildPrefixIcon(),
        suffixIcon:
            widget.showVisibilityToggle && !widget.visibilityToggleOnPrefix
            ? _buildVisibilityToggle()
            : widget.suffixIconWidget ?? _buildSuffixIcon(),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.neutral400),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.neutral400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.neutral400, width: 1.2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
      ),
      style: const TextStyle(color: AppColors.neutral900),
    );
  }

  Widget? _buildVisibilityToggle() {
    if (!widget.showVisibilityToggle) {
      return null;
    }

    return IconButton(
      icon: Icon(
        _obscureText ? Icons.visibility_off : Icons.visibility,
        color: AppColors.neutral400,
      ),
      onPressed: () {
        setState(() {
          _obscureText = !_obscureText;
        });
      },
    );
  }

  Widget? _buildPrefixIcon() {
    if (widget.prefixIcon == null) {
      return null;
    }

    return Icon(widget.prefixIcon, color: AppColors.neutral400);
  }

  Widget? _buildSuffixIcon() {
    if (widget.suffixIcon == null) {
      return null;
    }

    return Icon(widget.suffixIcon, color: AppColors.neutral400);
  }
}
