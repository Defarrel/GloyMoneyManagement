import 'package:flutter/material.dart';
import 'package:gloymoneymanagement/core/core.dart';

class CustomTextField2 extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? validator;
  final TextInputType? keyboardType;
  final bool readOnly;
  final Widget? suffixIcon;
  final VoidCallback? onTap;

  const CustomTextField2({
    super.key,
    required this.controller,
    required this.label,
    this.validator,
    this.keyboardType,
    this.readOnly = false,
    this.suffixIcon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      style: const TextStyle(fontSize: 14, color: Color.fromARGB(255, 0, 0, 0)),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Color.fromARGB(255, 0, 0, 0),
          fontSize: 14,
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.green, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      validator: (value) {
        if ((validator ?? '').isNotEmpty && (value == null || value.isEmpty)) {
          return validator;
        }
        return null;
      },
    );
  }
}
