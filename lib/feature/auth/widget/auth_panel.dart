import 'package:eub_connect/core/constant/app_color/app_colors.dart';
import 'package:flutter/material.dart';

class AuthPanel extends StatelessWidget {
  const AuthPanel({
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.children,
    required this.onSubmit,
    super.key,
  });

  final String title;
  final String subtitle;
  final String buttonLabel;
  final List<Widget> children;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE3E6EA)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(color: AppColors.textDark, fontSize: 14),
          ),
          const SizedBox(height: 22),
          ...children,
          const SizedBox(height: 22),
          ElevatedButton(onPressed: onSubmit, child: Text(buttonLabel)),
        ],
      ),
    );
  }
}
