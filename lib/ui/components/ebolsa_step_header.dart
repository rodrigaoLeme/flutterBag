import 'package:flutter/material.dart';

import '../helpers/themes/app_text_styles.dart';

class EbolsaStepHeader extends StatelessWidget {
  final String title;
  final String? description;
  final Widget? descriptionWidget;
  final Widget? trailing;

  const EbolsaStepHeader({
    super.key,
    required this.title,
    this.description,
    this.descriptionWidget,
    this.trailing,
  }) : assert(
          description != null || descriptionWidget != null,
          'Provide description or descriptionWidget',
        );

  @override
  Widget build(BuildContext context) {
    final descriptionContent = descriptionWidget ??
        Text(
          description!,
          style: AppTextStyles.bodyMedium,
        );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.titleLarge,
              ),
              const SizedBox(height: 12),
              descriptionContent,
            ],
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: 16),
          trailing!,
        ],
      ],
    );
  }
}
