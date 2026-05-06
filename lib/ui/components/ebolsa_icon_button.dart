import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../helpers/themes/app_colors.dart';
import '../helpers/themes/app_text_styles.dart';

class EbolsaIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final bool isSecondary;
  final bool isOutlined;
  final String iconPath;

  const EbolsaIconButton({
    super.key,
    required this.onPressed,
    required this.label,
    required this.iconPath,
    this.isSecondary = false,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isSecondary) {
      return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 18),
          foregroundColor: AppColors.textSecondaryLight,
          backgroundColor: AppColors.secondary,
          minimumSize: const Size(double.infinity, 48),
          side: BorderSide(width: 0, color: AppColors.secondary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          textStyle: AppTextStyles.labelLarge,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                iconPath,
                width: 20,
                color: AppColors.onSurfaceVariant,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(label),
            ],
          ),
        ),
      );
    }

    if (isOutlined) {
      return OutlinedButton(
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                iconPath,
                width: 20,
                color: AppColors.onSurfaceVariant,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(label),
            ],
          ),
        ),
      );
    }

    return ElevatedButton(
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 20,
              color: Colors.white,
            ),
            const SizedBox(
              width: 8,
            ),
            Text(label),
          ],
        ),
      ),
    );
  }
}
