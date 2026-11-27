import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

import '../../../../../main/i18n/app_i18n.dart';
import '../../../../helpers/themes/themes.dart';

class DeclarationStep extends StatelessWidget {
  final String responsibleName;
  final int year;
  final bool accepted;
  final ValueChanged<bool> onAcceptedChanged;

  const DeclarationStep({
    super.key,
    required this.responsibleName,
    required this.year,
    required this.accepted,
    required this.onAcceptedChanged,
  });

  @override
  Widget build(BuildContext context) {
    final i18n = AppI18n.current;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(i18n.declarationStepTitle, style: AppTextStyles.headlineSmall),
        const SizedBox(height: 16),
        MarkdownBody(
          data: i18n.documentDeclarationText(responsibleName, year),
          styleSheet: MarkdownStyleSheet(
            blockSpacing: 16,
            p: AppTextStyles.bodyMedium,
            strong:
                AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        CheckboxListTile(
          value: accepted,
          onChanged: (v) => onAcceptedChanged(v ?? false),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
          title: Text(
            i18n.documentDeclarationAccept,
            style: AppTextStyles.bodyLarge,
          ),
        ),
      ],
    );
  }
}
