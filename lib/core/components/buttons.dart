import 'package:flutter/material.dart';
import '../constants/colors.dart';

enum ButtonStyleType { filled, outlined }

class Button extends StatelessWidget {
  const Button.filled({
    super.key,
    required this.onPressed,
    required this.label,
    this.style = ButtonStyleType.filled,
    this.color = AppColors.primary,
    this.textColor = Colors.white,
    this.width = double.infinity,
    this.height = 56.0,
    this.borderRadius = 20.0,
    this.icon,
    this.suffixIcon,
    this.disabled = false,
    this.fontSize = 16.0,
  });

  const Button.outlined({
    super.key,
    required this.onPressed,
    required this.label,
    this.style = ButtonStyleType.outlined,
    this.color = Colors.transparent,
    this.textColor = AppColors.primary,
    this.width = double.infinity,
    this.height = 56.0,
    this.borderRadius = 20.0,
    this.icon,
    this.suffixIcon,
    this.disabled = false,
    this.fontSize = 16.0,
  });

  final VoidCallback? onPressed;
  final String label;
  final ButtonStyleType style;
  final Color color;
  final Color textColor;
  final double? width;
  final double height;
  final double borderRadius;
  final Widget? icon;
  final Widget? suffixIcon;
  final bool disabled;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: style == ButtonStyleType.filled
          ? ElevatedButton(
              onPressed: disabled ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: textColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                textStyle: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: _buildContent(),
            )
          : OutlinedButton(
              onPressed: disabled ? null : onPressed,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                textStyle: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: _buildContent(),
            ),
    );
  }

  Widget _buildContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) icon!,
        if (icon != null && label.isNotEmpty)
          const SizedBox(width: 10.0),
        Text(label),
        if (suffixIcon != null && label.isNotEmpty)
          const SizedBox(width: 10.0),
        if (suffixIcon != null) suffixIcon!,
      ],
    );
  }
}
