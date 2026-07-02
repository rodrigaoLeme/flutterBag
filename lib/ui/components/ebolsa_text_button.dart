import 'package:flutter/material.dart';

import '../helpers/themes/app_colors.dart';

class EbolsaTextButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final bool isSecondary;
  final bool isDanger;

  const EbolsaTextButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.isSecondary = false,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isDanger) {
      return TextButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyle(color: AppColors.errorContainer),
        ),
      );
    }

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
