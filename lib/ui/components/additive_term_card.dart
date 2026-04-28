import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/notice_entity.dart';
import '../../main/i18n/app_i18n.dart';
import '../helpers/themes/app_colors.dart';
import '../helpers/themes/app_text_styles.dart';

class AdditiveTermCard extends StatelessWidget {
  final AdditiveTermEntity additiveTerm;
  final VoidCallback onViewPressed;

  const AdditiveTermCard({
    super.key,
    required this.additiveTerm,
    required this.onViewPressed,
  });

  @override
  Widget build(BuildContext context) {
    final appStrings = AppI18n.current;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: AppColors.secondary,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              additiveTerm.name,
              textAlign: TextAlign.center,
              style: AppTextStyles.ebolsaTitleMedium,
            ),
          ),
          const SizedBox(height: 14),
          Divider(color: Colors.grey.shade400, height: 1),
          const SizedBox(height: 12),
          _buildInfoRow(
            appStrings.noticesTermsPublishedAtLabel,
            _formatDate(additiveTerm.publishedAt),
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            appStrings.noticesTermsModalityLabel,
            additiveTerm.modality,
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            appStrings.noticesTermsEnrollmentTypeLabel,
            additiveTerm.enrollmentType,
          ),
          const SizedBox(height: 16),
          Divider(color: Colors.grey.shade400, height: 1),
          TextButton(
            onPressed: onViewPressed,
            style: TextButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              foregroundColor: AppColors.primary,
              textStyle: AppTextStyles.m3LabelLarge,
            ),
            child: Text(appStrings.noticesTermsViewAdditiveTermAction),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.noticeFieldLabel,
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTextStyles.noticeFieldValue,
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm:ss').format(date);
  }
}
