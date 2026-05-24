import 'package:flutter/material.dart';

import '../helpers/themes/app_colors.dart';

class EbolsaTextButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final bool isSecondary;

  const EbolsaTextButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.isSecondary = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isSecondary) {
      return TextButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyle(color: AppColors.outline),
        ),
      );
    }
    return TextButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
