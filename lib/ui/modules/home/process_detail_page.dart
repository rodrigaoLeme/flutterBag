import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../domain/entities/announcement_enums.dart';
import '../../../domain/entities/process_enums.dart';
import '../../../domain/entities/process_period_entity.dart';
import '../../../domain/entities/scholarship_entity.dart';
import '../../../main/i18n/app_i18n.dart';
import '../../helpers/themes/themes.dart';
import 'components/banners/processes_banner_warning.dart';

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
        title: Text('Detalhe'), //Text(appStrings.processDetailTitle),
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
                  // Banner warning com botão continuar
                  ProcessesBannerWarning(
                    message: period?.registerPeriodLabel ?? '-',
                    onContinue: onContinue,
                  ),
                  const SizedBox(height: 12),

                  // Região administrativa + Edital
                  _InfoRow2Col(
                    label1: appStrings.administrativeRegion,
                    value1: 'Aqui era pra ter UCB-AP',
                    label2: appStrings.processCardNotice,
                    value2: period?.announcementTitle ?? '-',
                  ),
                  const SizedBox(height: 12),

                  // Nível + Tipo de bolsa
                  _InfoRow2Col(
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
                        child: _InfoCol(
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
                        child: _InfoCol(
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
            _DetailNavItem(
              icon: AppIcons.clock,
              label: 'Prazos', //appStrings.processDetailDeadlines,
              onTap: () {
                // TODO: navegar para tela de prazos
              },
            ),
            const Divider(height: 1),
            _DetailNavItem(
              icon: AppIcons.graduationCap,
              label: 'Candidatos', //appStrings.processDetailCandidates,
              onTap: () {
                // TODO: navegar para tela de candidatos
              },
            ),
            const Divider(height: 1),
            _DetailNavItem(
              icon: AppIcons.pdfFileIcon,
              label:
                  'Editais e Termos Aditivos', // appStrings.processDetailNoticesAndTerms,
              onTap: () {
                // TODO: navegar para tela de editais e termos
              },
            ),
            const Divider(height: 1),
            _DetailNavItem(
              icon: AppIcons.fileLines,
              label:
                  'Modelos de declaração', //appStrings.processDetailDeclarationModels,
              onTap: () {
                // TODO: navegar para tela de modelos de declaração
              },
            ),
            const Divider(height: 1),
            _DetailNavItem(
              icon: AppIcons.exclamationIcon,
              label:
                  'Cancelar Inscrição', //appStrings.processDetailCancelSubscription,
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

class _InfoRow2Col extends StatelessWidget {
  final String label1;
  final String value1;
  final String label2;
  final String value2;

  const _InfoRow2Col({
    required this.label1,
    required this.value1,
    required this.label2,
    required this.value2,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _InfoCol(
            label: label1,
            child: Text(
              value1,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondaryLight,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _InfoCol(
            label: label2,
            child: Text(
              value2,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondaryLight,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoCol extends StatelessWidget {
  final String label;
  final Widget child;

  const _InfoCol({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.textSecondaryLight,
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 5),
        child,
      ],
    );
  }
}

class _DetailNavItem extends StatelessWidget {
  final String icon;
  final String label;
  final bool dangerZone;
  final VoidCallback onTap;

  const _DetailNavItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.dangerZone = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      leading: SvgPicture.asset(
        icon,
        width: 18,
        height: 18,
        color: (!dangerZone) ? AppColors.surfaceColor : AppColors.error,
      ),
      title: Text(
        label,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w400,
              color: (!dangerZone) ? AppColors.surfaceColor : AppColors.error,
            ),
      ),
      trailing: SvgPicture.asset(
        AppIcons.arrowRightIconFill,
        width: 5,
        height: 10,
        color: (!dangerZone) ? AppColors.surfaceColor : AppColors.error,
      ),
      onTap: onTap,
    );
  }
}
