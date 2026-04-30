import 'package:flutter/material.dart';

import '../helpers/themes/app_colors.dart';
import '../helpers/themes/app_text_styles.dart';

class EbolsaButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final bool isSecondary;
  final bool isOutlined;

  const EbolsaButton({
    super.key,
    required this.onPressed,
    required this.label,
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
        child: Text(label),
      );
    }

    if (isOutlined) {
      return OutlinedButton(
        onPressed: onPressed,
        child: Text(label),
      );
    }

    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
