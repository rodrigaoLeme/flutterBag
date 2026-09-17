import 'package:flutter/material.dart';

import '../../../../domain/entities/announcement_enums.dart';
import '../../../../domain/entities/process_enums.dart';
import '../../../../domain/entities/scholarship_entity.dart';
import '../../../../main/factories/pages/new_scholarship/new_scholarship_page_factory.dart';
import '../../../../main/i18n/app_i18n.dart';
import '../../../components/components.dart';
import '../../new_request/new_scholarship_request_page.dart';
import '../components/cards/processes_cards_current.dart';
import '../process_detail_page.dart';
import '../renewal/renewal_scholarship_page.dart';

class ProcessesCurrentPage extends StatelessWidget {
  final int yearSelected;
  final ProcessesBanner processesBanner;
  final List<ScholarshipEntity> scholarships;

  const ProcessesCurrentPage({
    super.key,
    required this.yearSelected,
    required this.processesBanner,
    required this.scholarships,
  });

  @override
  Widget build(BuildContext context) {
    final appStrings = AppI18n.current;

    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 20, right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(appStrings.homeTitle,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            '${appStrings.homeSubtitleProcessInProgress} $yearSelected',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 40),
          ...scholarships.map((scholarship) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: ProcessCardCurrent(
                  administrativeRegion:
                      scholarship.administrativeAcronym ?? '-',
                  notice: scholarship.announcementTitle ?? '-',
                  level: scholarship.educationLevel?.label ?? '-',
                  scholarshipType: scholarship.scholarshipType?.label ?? '-',
                  processType: scholarship.processType == ProcessType.renewal
                      ? ProcessesType.renewProcess
                      : ProcessesType.newProcess,
                  step: _mapStep(scholarship.completedStep),
                  candidates: const [],
                  warningMessage: scholarship.bannerDeadline != null
                      ? 'Até ${_formatDate(scholarship.bannerDeadline!)}'
                      : '-',
                  // Botão continuar — habilitado só se canContinue
                  onContinue: scholarship.canContinue
                      ? () => _onContinue(context, scholarship)
                      : null,
                  onDetail: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ProcessDetailPage(
                        scholarship: scholarship,
                        period: scholarship.processPeriod,
                        step: _mapStep(scholarship.completedStep),
                        onContinue: scholarship.canContinue
                            ? () => _onContinue(context, scholarship)
                            : null,
                      ),
                    ),
                  ),
                  processesBanner: processesBanner,
                ),
              )),
          const SizedBox(height: 24),
          // Botões de nova solicitação e renovação
          Row(
            children: [
              Expanded(
                child: EbolsaButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          makeNewScholarshipPage(lockedYear: yearSelected),
                    ),
                  ),
                  label: appStrings.homeNewScholarshipButton,
                  isOutlined: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: EbolsaButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const RenewalScholarshipPage(),
                    ),
                  ),
                  label: appStrings.homeRenewScholarshipButton,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  void _onContinue(BuildContext context, ScholarshipEntity scholarship) {
    if (scholarship.processPeriodId == null) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NewScholarshipRequestPage(
          processPeriodId: scholarship.processPeriodId!,
          scholarshipId: scholarship.id,
        ),
      ),
    );
  }

  ProcessSteps _mapStep(int? completedStep) {
    switch (completedStep) {
      case 1:
        return ProcessSteps.initial;
      case 2:
        return ProcessSteps.register;
      case 3:
        return ProcessSteps.documentation;
      case 4:
        return ProcessSteps.verification;
      case 5:
        return ProcessSteps.analysis;
      case 6:
        return ProcessSteps.completed;
      default:
        return ProcessSteps.initial;
    }
  }
}
