import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/app_styles.dart';

class CustomTextField extends StatelessWidget {
  final String validator;
  final TextEditingController controller;
  final String label;
  final Function(String value)? onChanged;
  final bool obscureText;
  final TextInputType? keyboardType;
  final bool showLabel;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool readOnly;
  final int maxLines;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.onChanged,
    this.obscureText = false,
    this.keyboardType,
    this.showLabel = true,
    this.prefixIcon,
    this.suffixIcon,
    this.readOnly = false,
    this.maxLines = 1,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel) ...[
          Text(
            label,
            style: AppStyles.subtitle,
          ),
          const SizedBox(height: 8.0),
        ],
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (vl) {
            if (vl == null || vl.isEmpty) {
              return validator;
            }
            return null;
          },
          controller: controller,
          onChanged: onChanged,
          obscureText: obscureText,
          keyboardType: keyboardType,
          readOnly: readOnly,
          maxLines: maxLines,
          decoration: InputDecoration(
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: Colors.white,
            hintText: label,
            hintStyle: AppStyles.small,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: const BorderSide(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }
}
