import 'package:flutter/material.dart';

import '../../../../domain/entities/scholarship_entity.dart';
import '../../../../main/factories/pages/new_scholarship_request/new_scholarship_request_presenter_factory.dart';
import '../../../../main/i18n/app_i18n.dart';
import '../../../components/components.dart';
import '../../new_request/new_scholarship_request_page.dart';
import '../components/cards/processes_cards_current.dart';

class ProcessesCurrentPage extends StatefulWidget {
  final int yearSelected;
  final ProcessesBanner processesBanner;
  final List<ScholarshipEntity> scholarships;

  const ProcessesCurrentPage({
    super.key,
    required this.processesBanner,
    required this.yearSelected,
    required this.scholarships,
  });

  @override
  State<ProcessesCurrentPage> createState() => _ProcessesCurrentPageState();
}

class _ProcessesCurrentPageState extends State<ProcessesCurrentPage> {
  void _onContinue(BuildContext context, ScholarshipEntity scholarship) {
    if (scholarship.processPeriodId == null) return;

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
            '${appStrings.homeSubtitleProcessInProgress} ${widget.yearSelected}', // appStrings.homeSubtitleFinishedProcess,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 40),
          ProcessCardCurrent(
            administrativeRegion: 'APAC - UCB',
            notice: '01/2026',
            level: 'Ensino Superior',
            scholarshipType: 'CEBAS',
            processType: ProcessesType.newProcess,
            step: ProcessSteps.verification,
            candidates: [
              'Maria Júlia Padilha da Silva',
              'João Padilha da Silva',
              'André Padilha da Silva',
              'Mirela Padilha da Silva',
              'Francisco Padilha da Silva'
            ],
            processesBanner: widget.processesBanner,
            warningMessage: 'Data limite para Inscrição: 30/03/2026',
            onViewProcess: () {
              // abre o detalhes
            },
            onContinue: () {
              // Continua a inscrição
            },
          ),
          const SizedBox(
            height: 24,
          ),
          Row(
            children: [
              Expanded(
                child: EbolsaButton(
                  onPressed: () {},
                  label: appStrings.homeNewScholarshipButton,
                  isOutlined: true,
                ),
              ),
              const SizedBox(
                width: 16,
              ),
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
}
