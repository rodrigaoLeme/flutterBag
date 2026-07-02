import 'package:flutter/material.dart';

import '../../../../../main/i18n/app_i18n.dart';
import '../../../../components/components.dart';
import '../../../../helpers/themes/themes.dart';

final appStrings = AppI18n.current;

class ProcessCardsTermsAndNotices extends StatelessWidget {
  final String announcementTitle;
  final String announcementDate;
  final String announcementLevel;
  final String announcementFileId;

  const ProcessCardsTermsAndNotices({
    super.key,
    required this.announcementTitle,
    required this.announcementDate,
    required this.announcementLevel,
    required this.announcementFileId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 40),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.borderLight,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
            child: Center(
              child: Text(
                announcementTitle,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
          const Divider(
            height: 1,
            endIndent: 16,
            indent: 16,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 32, right: 32, top: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoRow(
                  label: appStrings.noticesTermsPublishedAtLabel,
                  value: announcementDate,
                ),
                const SizedBox(height: 12),
                _InfoRow(
                  label: appStrings.noticesTermsLevelLabel,
                  value: announcementLevel,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Divider(
            height: 1,
            endIndent: 16,
            indent: 16,
          ),
          const SizedBox(height: 8),
          Center(
            child: EbolsaTextButton(
                onPressed: () {},
                label: appStrings.noticesTermsViewNoticeAction),
          ),
          const SizedBox(height: 11),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondaryLight,
              ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
}
