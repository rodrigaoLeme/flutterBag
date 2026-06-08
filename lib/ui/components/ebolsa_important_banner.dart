import 'package:flutter/material.dart';

import '../helpers/themes/app_colors.dart';
import '../helpers/themes/app_text_styles.dart';

class EbolsaImportantBanner extends StatelessWidget {
  final String title;
  final String message;
  final Color? backgroundColor;

  const EbolsaImportantBanner({
    super.key,
    required this.title,
    required this.message,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color:
            backgroundColor ?? Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  title,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.onSurface,
                  ),
                  maxLines: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
        ],
      ),
    );
  }
}
