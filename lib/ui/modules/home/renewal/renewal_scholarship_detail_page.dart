import 'package:flutter/material.dart';

import '../../../../domain/entities/renewal_process_entity.dart';
import '../../../../main/i18n/app_i18n.dart';
import '../../../helpers/themes/themes.dart';
import '../../new_request/new_scholarship_request_page.dart';

class _RenewalCandidate {
  final String name;
  final String school;

  const _RenewalCandidate({required this.name, required this.school});
}

class RenewalScholarshipDetailPage extends StatelessWidget {
  final RenewalProcessEntity process;

  const RenewalScholarshipDetailPage({
    super.key,
    required this.process,
  });

  // Mock de candidatos com unidade escolar
  static const _candidates = [
    _RenewalCandidate(
      name: 'Maria Julia Padilha da Silva',
      school: 'Colégio Adventista de Hortolândia',
    ),
    _RenewalCandidate(
      name: 'João da Padilha da Silva',
      school: 'Colégio Adventista de Hortolândia',
    ),
  ];

  // Mock de datas da timeline
  static final _deadlines = [
    _TimelineItem(
        date: '20/10/25', label: 'Inic. das\nInscrições', isPast: true),
    _TimelineItem(
        date: '22/10/25', label: 'Tér. das\nInscrições', isPast: false),
    _TimelineItem(
        date: '26/10/25', label: 'Limite envio de\nDocumentos', isPast: false),
    _TimelineItem(date: '10/12/25', label: 'Resultados', isPast: false),
  ];

  @override
  Widget build(BuildContext context) {
    final appStrings = AppI18n.current;

    return Scaffold(
      appBar: AppBar(
        title: Text(appStrings.renewalScholarshipTitle),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Região administrativa em destaque
                  Text(
                    'Região Administrativa: ${process.administrativeRegion}',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.sysLightPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: 16),

                  // Etapas e Prazos
                  Text(
                    appStrings.renewalDetailDeadlinesTitle,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    // TODO: Ajustar o ano correto
                    '${appStrings.renewalDetailDeadlinesSubtitle} 2027',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondaryLight,
                        ),
                  ),
                  const SizedBox(height: 24),

                  // Timeline horizontal
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.outlineVariant,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _HorizontalTimeline(items: _deadlines),
                  ),
                  const SizedBox(height: 32),

                  // Candidatos
                  Text(
                    appStrings.renewalDetailCandidatesTitle,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    appStrings.renewalDetailCandidatesSubtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondaryLight,
                        ),
                  ),
                  const SizedBox(height: 24),

                  ListView.separated(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _candidates.length,
                    separatorBuilder: (_, __) => const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Divider(
                        height: 30,
                        endIndent: 20,
                      ),
                    ),
                    itemBuilder: (context, index) {
                      final candidate = _candidates[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            candidate.name,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            appStrings.processCardSchoolUnit,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppColors.onSurfaceVariant,
                                ),
                          ),
                          Text(
                            candidate.school,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Botões fixos no rodapé
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextButton(
                  onPressed: () {
                    // TODO: abrir PDF do edital
                  },
                  child: Text(
                    appStrings.renewalDetailViewNotice,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    // TODO: substituir por processPeriodId real
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const NewScholarshipRequestPage(
                          processPeriodId: '',
                        ),
                      ),
                    );
                  },
                  child: Text(appStrings.renewalDetailStartButton),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineItem {
  final String date;
  final String label;
  final bool isPast;

  const _TimelineItem({
    required this.date,
    required this.label,
    required this.isPast,
  });
}

class _HorizontalTimeline extends StatelessWidget {
  final List<_TimelineItem> items;

  const _HorizontalTimeline({required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < items.length; i++) ...[
              Container(
                width: 16,
                height: 16,
                margin: EdgeInsets.only(right: 10, left: 10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: items[i].isPast
                      ? AppColors.primary
                      : AppColors.secondaryContainer,
                ),
              ),
              if (i < items.length - 1)
                Expanded(
                  child: Container(
                    height: 1,
                    color: AppColors.borderLight,
                  ),
                ),
            ]
          ],
        ),
        Container(
          height: 24,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int i = 0; i < items.length; i++) ...[
              Container(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      items[i].date,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      textAlign: TextAlign.center,
                      items[i].label,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: AppColors.textSecondaryLight),
                    ),
                  ],
                ),
              ),
              if (i < items.length - 1) Spacer(),
            ],
          ],
        )
      ],
    );

    /// Opção 2 de exibição
    // return Row(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     for (int i = 0; i < items.length; i++) ...[
    //       Expanded(
    //         child: Column(
    //           children: [
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.start,
    //               children: [
    //                 Container(
    //                   width: 16,
    //                   height: 16,
    //                   //margin: EdgeInsets.only(right: 10, left: 10),
    //                   decoration: BoxDecoration(
    //                     shape: BoxShape.circle,
    //                     color: items[i].isPast
    //                         ? AppColors.primary
    //                         : AppColors.secondaryContainer,
    //                   ),
    //                 ),
    //                 if (i < items.length - 1)
    //                   Expanded(
    //                     child: Container(
    //                       height: 1,
    //                       color: AppColors.borderLight,
    //                     ),
    //                   ),
    //               ],
    //             ),
    //             const SizedBox(height: 24),
    //             Align(
    //               alignment: Alignment.centerLeft,
    //               child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   Text(
    //                     items[i].date,
    //                     style: Theme.of(context)
    //                         .textTheme
    //                         .titleSmall
    //                         ?.copyWith(fontWeight: FontWeight.w700),
    //                   ),
    //                   Text(
    //                     items[i].label,
    //                     style: Theme.of(context)
    //                         .textTheme
    //                         .bodySmall
    //                         ?.copyWith(color: AppColors.textSecondaryLight),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ],
    //   ],
    // );
  }
}
