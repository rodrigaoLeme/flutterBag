import 'package:flutter/material.dart';

import '../../../../../domain/entities/process_enums.dart';
import '../../../../../main/i18n/app_i18n.dart';
import '../../../../components/ebolsa_text_button.dart';
import '../../../../helpers/themes/themes.dart';
import '../../helpers/info_table_view_helper.dart';
import '../banners/processes_banner_error.dart';
import '../banners/processes_banner_pending_documents_warning.dart';
import '../banners/processes_banner_warning.dart';

final appStrings = AppI18n.current;

class ProcessCardCurrent extends StatelessWidget {
  final String administrativeRegion;
  final String notice;
  final String level;
  final String scholarshipType;
  final ProcessesType processType;
  final ProcessSteps step;
  final List<String> candidates;
  final ProcessesBanner processesBanner;
  final String warningMessage;
  final VoidCallback? onDetail;
  final VoidCallback? onContinue;

  const ProcessCardCurrent({
    super.key,
    required this.administrativeRegion,
    required this.notice,
    required this.level,
    required this.scholarshipType,
    required this.processType,
    required this.step,
    required this.candidates,
    required this.processesBanner,
    required this.warningMessage,
    this.onDetail,
    this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
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
          if (processesBanner == ProcessesBanner.warning)
            ProcessesBannerWarning(
              message: warningMessage,
              onContinue: onContinue,
            ),
          if (processesBanner == ProcessesBanner.pending)
            ProcessesBannerPendingDocumentsWarning(message: warningMessage),
          if (processesBanner == ProcessesBanner.error)
            ProcessesBannerError(message: warningMessage),

          // Região administrativa + Edital
          InfoRow2Col(
            label1: appStrings.administrativeRegion,
            value1: 'Aqui era pra ter UCB-AP',
            label2: appStrings.processCardNotice,
            value2: administrativeRegion,
          ),
          const SizedBox(height: 12),

          // Nível + Tipo de bolsa
          InfoRow2Col(
            label1: appStrings.processCardLevel,
            value1: level,
            label2: appStrings.processCardScholarshipType,
            value2: scholarshipType,
          ),
          const SizedBox(height: 12),

          // Tipo de inscrição + Etapa
          Row(
            children: [
              Expanded(
                child: InfoCol(
                  label: appStrings.processCardProcessType,
                  child: Text(
                    processType.label,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondaryLight,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: InfoCol(
                  label: appStrings.processCardStep,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: step.color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      step.label,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColors.onSurface,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Candidatos
          if (candidates.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.outlineVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Text(
                      candidates.length == 1
                          ? appStrings.processCardCandidateSingular
                          : appStrings.processCardCandidatePlural,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondaryLight,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (candidates.isEmpty)
                    Center(
                      child: Text(
                        '-',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.textSecondaryLight,
                            ),
                      ),
                    )
                  else
                    ...candidates.map(
                      (name) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Center(
                          child: Text(
                            name,
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: AppColors.textSecondaryLight,
                                      fontWeight: FontWeight.w500,
                                    ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],

          // Botão de Detalhes
          const SizedBox(height: 16),
          Center(
            child: EbolsaTextButton(
              onPressed: onDetail,
              label: appStrings.processCardDetaiButton,
            ),
          ),
        ],
      ),
    );
  }
}
