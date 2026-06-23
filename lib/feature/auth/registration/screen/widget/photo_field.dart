import 'package:eub_connect/core/constant/app_color/app_colors.dart';
import 'package:flutter/material.dart';

class PhotoField extends StatelessWidget {
  const PhotoField({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF4F6F9),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE3E6EA)),
        ),
        child: Row(
          children: [
            Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE3E6EA)),
              ),
              child: const Icon(
                Icons.add_a_photo_outlined,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Profile Photo',
                    style: TextStyle(
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Upload photo option',
                    style: TextStyle(color: Color(0xFF707070), fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
