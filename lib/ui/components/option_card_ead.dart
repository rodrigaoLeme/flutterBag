import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../helpers/themes/app_colors.dart';

class OptionCardEAD extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback? onTap;

  const OptionCardEAD({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.onSurfaceLight,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              color: AppColors.primaryDark,
              width: 18,
              height: 18,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryDark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
