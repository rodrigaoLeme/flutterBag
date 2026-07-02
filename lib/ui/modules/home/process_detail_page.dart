import 'package:flutter/material.dart';

import '../../../domain/entities/announcement_enums.dart';
import '../../../domain/entities/process_enums.dart';
import '../../../domain/entities/process_period_entity.dart';
import '../../../domain/entities/scholarship_entity.dart';
import '../../../main/i18n/app_i18n.dart';
import '../../components/components.dart';
import '../../helpers/themes/themes.dart';
import 'components/banners/processes_banner_warning.dart';
import 'helpers/info_table_view_helper.dart';
import 'process_candidates_page.dart';
import 'process_deadlines_page.dart';
import 'process_declaration_models_page.dart';
import 'process_terms_page.dart';

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

  void _showCancelDialog(BuildContext context) {
    EbolsaDialogWithCancel.show(
      context: context,
      title: AppI18n.current.processCancelDialogTitle,
      description: AppI18n.current.processCancelDialogDescription,
      actions: [
        EbolsaDialogAction(
          label: AppI18n.current.processCancelDialogConfirm,
          isPrimary: false,
          isDanger: true,
          onPressed: () => _showCancelReasonDialog(context),
        ),
        EbolsaDialogAction(
          label: AppI18n.current.processCancelDialogDeny,
          isPrimary: true,
          onPressed: () {},
        ),
      ],
    );
  }

  void _showCancelReasonDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _CancelReasonDialog(),
    );
  }

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
              ),
            ),
            const Divider(height: 1),
            DetailNavItem(
              icon: AppIcons.graduationCap,
              label: appStrings.processDetailCandidates,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ProcessCandidatesPage(),
                ),
              ),
            ),
            const Divider(height: 1),
            DetailNavItem(
              icon: AppIcons.pdfFileIcon,
              label: appStrings.processDetailNoticesAndTerms,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const ProcessTermsPage(),
                ),
              ),
            ),
            const Divider(height: 1),
            DetailNavItem(
              icon: AppIcons.fileLines,
              label: appStrings.processDetailDeclarationModels,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const ProcessDeclarationModelsPage(),
                ),
              ),
            ),
            const Divider(height: 1),
            DetailNavItem(
              icon: AppIcons.banIcon,
              label: appStrings.processDetailCancelSubscription,
              dangerZone: true,
              onTap: () => _showCancelDialog(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _CancelReasonDialog extends StatefulWidget {
  const _CancelReasonDialog();

  @override
  State<_CancelReasonDialog> createState() => _CancelReasonDialogState();
}

class _CancelReasonDialogState extends State<_CancelReasonDialog> {
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appStrings = AppI18n.current;

    return AlertDialog(
      title: Text(
        appStrings.processCancelReasonDialogTitle,
        style: AppTextStyles.titleLarge,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          TextField(
            controller: _reasonController,
            maxLines: 4,
            maxLength: 500,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: appStrings.processCancelReasonDialogHint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              alignLabelWithHint: true,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _reasonController.text.trim().isEmpty
              ? null
              : () {
                  Navigator.of(context).pop();
                  // TODO: chamar endpoint com _reasonController.text
                },
          child: Text(
            appStrings.processCancelReasonDialogConfirm,
            style: AppTextStyles.bodyMedium.copyWith(
              color: _reasonController.text.trim().isEmpty
                  ? AppColors.textSecondaryLight
                  : AppColors.errorContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            appStrings.processCancelDialogDeny,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
