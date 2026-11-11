import 'package:flutter/material.dart';

import '../../../../domain/entities/announcement_enums.dart';
import '../../../../domain/entities/available_announcement_entity.dart';
import '../../../../main/factories/pages/new_scholarship/new_scholarship_page_factory.dart';
import '../../../../main/factories/pages/notices_terms/notice_document_page_factory.dart';
import '../../../../main/i18n/app_i18n.dart';
import '../../../helpers/themes/themes.dart';
import '../../notices_terms/notice_document_page.dart';

class RenewalScholarshipDetailPage extends StatelessWidget {
  final AvailableAnnouncementEntity announcement;
  final int year;

  const RenewalScholarshipDetailPage({
    super.key,
    required this.announcement,
    required this.year,
  });

  List<_TimelineItem> get _deadlines {
    final period = announcement.processPeriod;
    return [
      _TimelineItem(
        date: _formatDate(period?.registerStart),
        label: 'Inic. das\nInscrições',
        isPast: _isPast(period?.registerStart),
      ),
      _TimelineItem(
        date: _formatDate(period?.registerEnd),
        label: 'Tér. das\nInscrições',
        isPast: _isPast(period?.registerEnd),
      ),
      _TimelineItem(
        date: _formatDate(period?.documentationUploadDeadLine),
        label: 'Limite envio de\nDocumentos',
        isPast: _isPast(period?.documentationUploadDeadLine),
      ),
      _TimelineItem(
        date: _formatDate(period?.resultRelease),
        label: 'Resultados',
        isPast: _isPast(period?.resultRelease),
      ),
    ];
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final shortYear = (date.year % 100).toString().padLeft(2, '0');
    return '$day/$month/$shortYear';
  }

  bool _isPast(DateTime? date) {
    if (date == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(date.year, date.month, date.day);
    return day.isBefore(today);
  }

  String _display(String? value) {
    final text = value?.trim();
    if (text == null || text.isEmpty) return '-';
    return text;
  }

  String get _noticeTitle {
    final title = announcement.title?.trim();
    if (title != null && title.isNotEmpty) return title;
    return _display(announcement.editalNumber);
  }

  AnnouncementSchoolEntity? get _renewalSchool {
    final candidateSchool = announcement.candidates
        .map((candidate) => candidate.studentSchool?.trim().toLowerCase())
        .whereType<String>()
        .where((name) => name.isNotEmpty)
        .firstOrNull;
    if (candidateSchool != null) {
      for (final school in announcement.schools) {
        if (school.name?.trim().toLowerCase() == candidateSchool) {
          return school;
        }
      }
    }
    if (announcement.schools.isNotEmpty) return announcement.schools.first;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final appStrings = AppI18n.current;
    final candidates = announcement.candidates;
    final canStart =
        announcement.canRegister && announcement.processPeriod != null;

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
                    'Região Administrativa: ${_display(announcement.administrativeAcronym)}',
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
                    '${appStrings.renewalDetailDeadlinesSubtitle} $year',
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
                    itemCount: candidates.length,
                    separatorBuilder: (_, __) => const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Divider(
                        height: 30,
                        endIndent: 20,
                      ),
                    ),
                    itemBuilder: (context, index) {
                      final candidate = candidates[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _display(candidate.studentName),
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
                            _display(candidate.studentSchool),
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
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => NoticeDocumentPage(
                          presenter: makeNoticeDocumentPresenter(),
                          announcementId: announcement.id,
                          title: _noticeTitle,
                        ),
                      ),
                    );
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
                  onPressed: canStart
                      ? () {
                          final school = _renewalSchool;
                          final candidateSchool = announcement.candidates
                              .map((candidate) => candidate.studentSchool?.trim())
                              .whereType<String>()
                              .where((name) => name.isNotEmpty)
                              .firstOrNull;
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => makeNewScholarshipPage(
                                lockedYear: year,
                                processType: ProcessType.renewal,
                                lockedCity: school?.city,
                                lockedSchoolId: school?.id,
                                lockedSchoolName:
                                    school?.name ?? candidateSchool,
                              ),
                            ),
                          );
                        }
                      : null,
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
