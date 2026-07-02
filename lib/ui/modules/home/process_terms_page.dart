import 'package:flutter/material.dart';

import '../../../main/i18n/app_i18n.dart';
import '../../helpers/themes/themes.dart';
import 'components/cards/processes_cards_terms_and_notices.dart';

class ProcessTermsPage extends StatelessWidget {
  // Por enquanto mockado — futuramente receberá List<StudentEntity>
  const ProcessTermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appStrings = AppI18n.current;

    return Scaffold(
      appBar: AppBar(
        title: Text(appStrings.processDetailNoticesAndTerms),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              appStrings.processTermsAndNoticesTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              appStrings.processTermsAndNoticesSubtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondaryLight,
                  ),
            ),
            const SizedBox(height: 24),

            // Mock — substituir por lista real quando tiver os dados
            ProcessCardsTermsAndNotices(
              announcementTitle: 'Edital Nº 01/2026',
              announcementDate: '27/02/2026',
              announcementLevel: 'Básico',
              announcementFileId: 'loremIpsumDolorSitAmet',
            ),
            ProcessCardsTermsAndNotices(
              announcementTitle: 'Edital Nº 01/2026',
              announcementDate: '27/02/2026',
              announcementLevel: 'Básico',
              announcementFileId: 'loremIpsumDolorSitAmet',
            ),
          ],
        ),
      ),
    );
  }
}
