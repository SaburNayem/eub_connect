import 'package:eub_connect/core/constant/app_color/app_colors.dart';
import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    required this.label,
    required this.icon,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    super.key,
  });

  final String label;
  final IconData icon;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary),
      ),
    );
  }
}
