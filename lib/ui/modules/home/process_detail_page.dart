import 'package:flutter/material.dart';

import '../../../domain/entities/announcement_enums.dart';
import '../../../domain/entities/process_enums.dart';
import '../../../domain/entities/process_period_entity.dart';
import '../../../domain/entities/scholarship_entity.dart';
import '../../../main/i18n/app_i18n.dart';
import '../../helpers/themes/themes.dart';
import 'components/banners/processes_banner_warning.dart';
import 'helpers/info_table_view_helper.dart';
import 'process_deadlines_page.dart';

class ProcessDetailPage extends StatelessWidget {
  final ScholarshipEntity scholarship;
  final ProcessPeriodAvailableEntity? period;
  final ProcessSteps step;
  final VoidCallback? onContinue;

  const ProcessDetailPage({
    super.key,
    required this.scholarship,
    required this.step,
    this.period,
    this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final appStrings = AppI18n.current;

    return Scaffold(
      appBar: AppBar(
        title: Text(appStrings.processDetailTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Card principal — mesmo visual da home
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderLight, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ----- Banner warnings com botão continuar ---
                  // TODO: Implementar outros banners deposi
                  ProcessesBannerWarning(
                    message: period?.registerPeriodLabel ?? '-',
                    onContinue: onContinue,
                  ),
                  const SizedBox(height: 12),

                  // Região administrativa + Edital
                  InfoRow2Col(
                    label1: appStrings.administrativeRegion,
                    value1: 'Aqui era pra ter UCB-AP',
                    label2: appStrings.processCardNotice,
                    value2: period?.announcementTitle ?? '-',
                  ),
                  const SizedBox(height: 12),

                  // Nível + Tipo de bolsa
                  InfoRow2Col(
                    label1: appStrings.processCardLevel,
                    value1: period?.educationLevel?.label ?? '-',
                    label2: appStrings.processCardScholarshipType,
                    value2: period?.scholarshipType?.label ?? '-',
                  ),
                  const SizedBox(height: 12),

                  // Tipo de inscrição + Etapa
                  Row(
                    children: [
                      Expanded(
                        child: InfoCol(
                          label: appStrings.processCardProcessType,
                          child: Text(
                            scholarship.processType == ProcessType.renewal
                                ? appStrings.renewProcess
                                : appStrings.newProcess,
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: step.color,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              step.label,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: AppColors.outlineVariant,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Text(
                            appStrings.processCardCandidatePlural,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppColors.textSecondaryLight,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),

                        // if (candidates.isEmpty)
                        //   Center(
                        //     child: Text(
                        //       '-',
                        //       style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        //             color: AppColors.textSecondaryLight,
                        //           ),
                        //     ),
                        //   )
                        // else
                        //   ...candidates.map(
                        //     (name) => Padding(
                        //       padding: const EdgeInsets.only(bottom: 6),
                        //       child: Center(
                        //         child: Text(
                        //           name,
                        //           style:
                        //               Theme.of(context).textTheme.bodyLarge?.copyWith(
                        //                     color: AppColors.textSecondaryLight,
                        //                     fontWeight: FontWeight.w500,
                        //                   ),
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Lista de botões de navegação
            DetailNavItem(
                icon: AppIcons.clock,
                label: appStrings.processDetailDeadlines,
                onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ProcessDeadlinesPage(period: period),
                      ),
                    )),
            const Divider(height: 1),
            DetailNavItem(
              icon: AppIcons.graduationCap,
              label: appStrings.processDetailCandidates,
              onTap: () {
                // TODO: navegar para tela de candidatos
              },
            ),
            const Divider(height: 1),
            DetailNavItem(
              icon: AppIcons.pdfFileIcon,
              label: appStrings.processDetailNoticesAndTerms,
              onTap: () {
                // TODO: navegar para tela de editais e termos
              },
            ),
            const Divider(height: 1),
            DetailNavItem(
              icon: AppIcons.fileLines,
              label: appStrings.processDetailDeclarationModels,
              onTap: () {
                // TODO: navegar para tela de modelos de declaração
              },
            ),
            const Divider(height: 1),
            DetailNavItem(
              icon: AppIcons.banIcon,
              label: appStrings.processDetailCancelSubscription,
              dangerZone: true,
              onTap: () {
                // TODO: Chamar modal de confirmação
              },
            ),
          ],
        ),
      ),
    );
  }
}
