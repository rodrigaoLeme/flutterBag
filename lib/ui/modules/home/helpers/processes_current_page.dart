import 'package:flutter/material.dart';

import '../../../../domain/entities/announcement_enums.dart';
import '../../../../domain/entities/process_enums.dart';
import '../../../../domain/entities/process_period_entity.dart';
import '../../../../domain/entities/scholarship_entity.dart';
import '../../../../main/factories/pages/new_scholarship/new_scholarship_page_factory.dart';
import '../../../../main/factories/pages/new_scholarship_request/new_scholarship_request_presenter_factory.dart';
import '../../../../main/i18n/app_i18n.dart';
import '../../../components/components.dart';
import '../../new_request/new_scholarship_request_page.dart';
import '../components/cards/processes_cards_current.dart';
import '../process_detail_page.dart';

class ProcessesCurrentPage extends StatelessWidget {
  final int yearSelected;
  final ProcessesBanner processesBanner;
  final List<ScholarshipEntity> scholarships;
  final List<ProcessPeriodAvailableEntity> availablePeriods;

  const ProcessesCurrentPage({
    super.key,
    required this.yearSelected,
    required this.processesBanner,
    required this.scholarships,
    required this.availablePeriods,
  });

  // Merge scholarship com period pelo processPeriodId
  ProcessPeriodAvailableEntity? _periodFor(ScholarshipEntity s) {
    try {
      return availablePeriods.firstWhere((p) => p.id == s.processPeriodId);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appStrings = AppI18n.current;

    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 20, right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            appStrings.homeTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            '${appStrings.homeSubtitleProcessInProgress} $yearSelected', // appStrings.homeSubtitleFinishedProcess,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 40),
          ...scholarships.map((scholarship) {
            final period = _periodFor(scholarship);
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ProcessCardCurrent(
                administrativeRegion: period?.announcementTitle ?? '-',
                notice: period?.announcementTitle ?? '-',
                level: period?.educationLevel?.label ?? '-',
                scholarshipType: period?.scholarshipType?.label ?? '-',
                processType: scholarship.processType == ProcessType.renewal
                    ? ProcessesType.renewProcess
                    : ProcessesType.newProcess,
                step: ProcessSteps.fromValue(scholarship.currentStep),
                candidates: const [],
                processesBanner: processesBanner,
                warningMessage: period?.registerPeriodLabel ?? '-',
                onContinue: scholarship.processPeriodId != null
                    ? () => _onContinue(context, scholarship)
                    : null,
                onDetail: () => _onDetail(context, scholarship, period),
              ),
            );
          }),
          const SizedBox(height: 18),
          Row(
            children: [
              Flexible(
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
              Flexible(
                child: EbolsaButton(
                  onPressed: () {},
                  label: appStrings.homeRenewScholarshipButton,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          EbolsaImportantBanner(
            title: appStrings.homeImportantTitle,
            message: appStrings.homeImportantMessage,
          ),
          const SizedBox(height: 23),
        ],
      ),
    );
  }

  void _onContinue(BuildContext context, ScholarshipEntity scholarship) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NewScholarshipRequestPage(
          processPeriodId: scholarship.processPeriodId!,
          presenter: makeNewRequestPresenter(
            processPeriodId: scholarship.processPeriodId!,
          ),
        ),
      ),
    );
    // O _initForm do presenter já verifica draft local e endpoint automaticamente
    // pra carregar os dados.
  }

  void _onDetail(BuildContext context, ScholarshipEntity scholarship,
      ProcessPeriodAvailableEntity? period) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProcessDetailPage(
          scholarship: scholarship,
          period: period,
          step: ProcessSteps.fromValue(scholarship.currentStep),
          onContinue: scholarship.processPeriodId != null
              ? () {
                  Navigator.of(context).pop(); // fecha o detail
                  _onContinue(context, scholarship);
                }
              : null,
        ),
      ),
    );
  }
}
