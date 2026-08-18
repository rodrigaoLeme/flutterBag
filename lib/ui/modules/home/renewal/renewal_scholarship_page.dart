import 'package:flutter/material.dart';

import '../../../../domain/entities/renewal_process_entity.dart';
import '../../../../main/i18n/app_i18n.dart';
import '../../../components/ebolsa_text_button.dart';
import '../../../helpers/themes/themes.dart';
import '../helpers/info_table_view_helper.dart';
import 'renewal_scholarship_detail_page.dart';

class RenewalScholarshipPage extends StatelessWidget {
  const RenewalScholarshipPage({super.key});

  // Mock — substituir por dados reais do endpoint
  static const _processes = [
    RenewalProcessEntity(
      administrativeRegion: 'APAC - UCB',
      notice: '01/2026',
      level: 'Ensino Superior',
      scholarshipType: 'CEBAS',
      candidates: ['Maria Julia Padilha da Silva'],
    ),
    RenewalProcessEntity(
      administrativeRegion: 'APAC - UCB',
      notice: '01/2026',
      level: 'Ensino Superior',
      scholarshipType: 'CEBAS',
      candidates: [
        'Maria Julia Padilha da Silva',
        'João Julia Padilha da Silva',
      ],
    ),
    RenewalProcessEntity(
      administrativeRegion: 'APAC - UCB',
      notice: '01/2026',
      level: 'Ensino Superior',
      scholarshipType: 'CEBAS',
      candidates: [
        'Maria Julia Padilha da Silva',
        'João Julia Padilha da Silva',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final appStrings = AppI18n.current;

    return Scaffold(
      appBar: AppBar(
        title: Text(appStrings.renewalScholarshipTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              appStrings.renewalScholarshipSubtitle,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 2),
            Text(
              appStrings.renewalScholarshipDescription,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondaryLight,
                  ),
            ),
            const SizedBox(height: 24),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _processes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final process = _processes[index];
                return _RenewalProcessCard(
                  process: process,
                  onDetails: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => RenewalScholarshipDetailPage(
                        process: process,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _RenewalProcessCard extends StatelessWidget {
  final RenewalProcessEntity process;
  final VoidCallback onDetails;

  const _RenewalProcessCard({
    required this.process,
    required this.onDetails,
  });

  @override
  Widget build(BuildContext context) {
    final appStrings = AppI18n.current;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Região administrativa e Ediral
                InfoRow2Col(
                  label1: appStrings.administrativeRegion,
                  value1: process.administrativeRegion,
                  label2: appStrings.processCardNotice,
                  value2: process.notice,
                ),

                const SizedBox(height: 12),

                // Nível e Tipo de Bolsa
                InfoRow2Col(
                  label1: appStrings.processCardLevel,
                  value1: process.level,
                  label2: appStrings.processCardScholarshipType,
                  value2: process.scholarshipType,
                ),

                const SizedBox(height: 12),

                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.outlineVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        appStrings.processCardCandidatePlural,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondaryLight,
                            ),
                      ),
                      const SizedBox(height: 8),
                      ...process.candidates.map(
                        (name) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            name,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Botão de Detalhes
          Center(
            child: EbolsaTextButton(
              onPressed: onDetails,
              label: appStrings.renewalScholarshipDetails,
            ),
          ),
        ],
      ),
    );
  }
}
