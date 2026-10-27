import 'package:flutter/material.dart';

import '../../../../domain/entities/renewal_process_entity.dart';
import '../../../../main/i18n/app_i18n.dart';
import '../../../components/ebolsa_button.dart';
import '../../../components/ebolsa_text_button.dart';
import '../../../helpers/themes/themes.dart';
import '../helpers/info_table_view_helper.dart';
import 'renewal_scholarship_detail_page.dart';

class RenewalScholarshipPage extends StatelessWidget {
  final List<RenewalProcessEntity> processes;

  const RenewalScholarshipPage({
    super.key,
    this.processes = const [],
  });

  @override
  Widget build(BuildContext context) {
    final appStrings = AppI18n.current;

    if (processes.isEmpty) {
      return _RenewalEmptyPage(appStrings: appStrings);
    }

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
              itemCount: processes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final process = processes[index];
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

class _RenewalEmptyPage extends StatelessWidget {
  final AppI18n appStrings;

  const _RenewalEmptyPage({required this.appStrings});

  static const _alertColor = Color(0xFFC62828);
  static const _alertBackground = Color(0xFFFDECEC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appStrings.renewalScholarshipTitle),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(12, 14, 14, 14),
                decoration: BoxDecoration(
                  color: _alertBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: _alertColor,
                      size: 22,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appStrings.renewalEmptyTitle,
                            style: AppTextStyles.titleSmall.copyWith(
                              color: _alertColor,
                              fontWeight: FontWeight.w700,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            appStrings.renewalEmptyMessage,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: _alertColor,
                              height: 1.35,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            appStrings.renewalEmptyContact,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: _alertColor,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const _RenewalEmptyIllustration(),
              const Spacer(),
              EbolsaButton(
                onPressed: () => Navigator.of(context).pop(),
                label: appStrings.renewalEmptyBackHome,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RenewalEmptyIllustration extends StatelessWidget {
  const _RenewalEmptyIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 190,
      height: 210,
      child: Stack(
        children: [
          Positioned(
            left: 6,
            top: 8,
            child: Transform.rotate(
              angle: -0.18,
              child: _ClipboardCard(
                clipColor: Color(0xFF8EA0C0),
              ),
            ),
          ),
          Positioned(
            left: 52,
            top: 28,
            child: _ClipboardCard(
              clipColor: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ClipboardCard extends StatelessWidget {
  final Color clipColor;

  const _ClipboardCard({required this.clipColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 124,
      height: 168,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: 16,
            child: Container(
              width: 124,
              height: 150,
              decoration: BoxDecoration(
                color: const Color(0xFFF7F8FB),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color(0xFFD5DCE6),
                  width: 1.6,
                ),
              ),
              padding: const EdgeInsets.fromLTRB(12, 30, 12, 14),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color(0xFFE6EAF2),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Container(
            width: 52,
            height: 16,
            decoration: BoxDecoration(
              color: clipColor,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          Positioned(
            top: 0,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.6),
                color: clipColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
