import 'package:flutter/material.dart';

import '../helpers/themes/app_colors.dart';
import '../helpers/themes/app_text_styles.dart';

class EbolsaButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final bool isSecondary;
  final bool isOutlined;
  final double? borderRadius;
  final double? height;
  final Color? backgroundColor;
  final TextStyle? textStyle;

  const EbolsaButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.isSecondary = false,
    this.isOutlined = false,
    this.borderRadius,
    this.height,
    this.backgroundColor,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    if (isSecondary) {
      return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 18),
          foregroundColor: AppColors.textSecondaryLight,
          backgroundColor: backgroundColor ?? AppColors.secondary,
          minimumSize: Size(double.infinity, height ?? 48),
          side: BorderSide(width: 0, color: AppColors.secondary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 30),
          ),
          textStyle: textStyle ?? AppTextStyles.labelLarge,
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
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        minimumSize: Size(double.infinity, height ?? 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 28),
        ),
        textStyle: textStyle ?? AppTextStyles.labelLarge,
      ),
      child: Text(label, style: textStyle),
    );
  }
}
