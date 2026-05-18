import 'package:flutter/material.dart';

import '../helpers/themes/app_colors.dart';
import '../helpers/themes/app_text_styles.dart';
import 'ebolsa_button.dart';

class EbolsaInfoSection {
  final String title;
  final String description;

  EbolsaInfoSection({required this.title, required this.description});
}

class EbolsaInfoBottomSheet {
  EbolsaInfoBottomSheet._();

  static Future<void> show(
    BuildContext context, {
    List<EbolsaInfoSection> sections = const [],
    IconData iconData = Icons.info_outline,
    Color iconColor = AppColors.alerta,
    String closeLabel = 'Fechar',
    double heightFactor = 0.66,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 12,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 8,
            ),
            child: SizedBox(
              height: MediaQuery.of(ctx).size.height * heightFactor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.outline,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: Icon(iconData, color: iconColor, size: 40),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          ...sections.expand((s) => [
                                Text(s.title, style: AppTextStyles.titleMedium),
                                const SizedBox(height: 8),
                                Text(s.description,
                                    style: AppTextStyles.bodyMedium),
                                const SizedBox(height: 16),
                              ]),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: EbolsaButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      label: closeLabel,
                      isSecondary: false,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
