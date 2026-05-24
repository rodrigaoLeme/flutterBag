import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/available_announcement_entity.dart';
import '../helpers/themes/themes.dart';
import '../modules/home/home_page.dart';
import 'components.dart';

class AvailableAnnouncementCard extends StatefulWidget {
  final AvailableAnnouncementEntity announcement;
  final VoidCallback? onViewPressed;
  final VoidCallback? onApplyPressed;

  const AvailableAnnouncementCard({
    super.key,
    required this.announcement,
    required this.onViewPressed,
    this.onApplyPressed,
  });

  @override
  State<AvailableAnnouncementCard> createState() =>
      _AvailableAnnouncementCardState();
}

class _AvailableAnnouncementCardState extends State<AvailableAnnouncementCard> {
  bool _schoolExpanded = false;
  final _dateFormat = DateFormat('dd/MM/yyyy HH:mm');

  String _formatDate(DateTime? date) =>
      date != null ? _dateFormat.format(date) : '-';

  String _formatDateOnly(DateTime? date) =>
      date != null ? DateFormat('dd/MM/yyyy').format(date) : '-';

  @override
  Widget build(BuildContext context) {
    final a = widget.announcement;
    final isEdital = a.isEdital;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.only(bottom: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Titulo
          Container(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
            child: Column(
              children: [
                Text(
                  '${isEdital ? appStrings.processCardNoticeSentence : appStrings.processCardAddendumSentence} Nº ${a.editalNumber ?? '-'}',
                  style: AppTextStyles.titleMedium
                      .copyWith(fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Divider(),
                const SizedBox(height: 8),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Período de Inscrição
                if (a.processPeriod != null) ...[
                  _InfoRow(
                    label: appStrings.noticesTermsRegistrationPeriod,
                    value:
                        '${_formatDateOnly(a.processPeriod!.registerStart)} até ${_formatDateOnly(a.processPeriod!.registerEnd)}',
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                ],

                // Data de Publicação
                _InfoRow(
                  label: appStrings.noticesTermsPublishedAtLabel,
                  value: _formatDate(a.editalReleaseDate),
                ),
                const SizedBox(
                  height: 8,
                ),

                // Nível de ensino e Tipod e Bolsa
                Row(
                  children: [
                    Expanded(
                      child: _InfoRow(
                        label: appStrings.noticesTermsLevelLabel,
                        value: a.educationLevel?.label ?? '-',
                      ),
                    ),
                    Expanded(
                      child: _InfoRow(
                        label: appStrings.noticesTermsModalityLabel2,
                        value: a.scholarshipType?.label ?? '-',
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),

                // Unidades que expandem
                GestureDetector(
                  onTap: () =>
                      setState(() => _schoolExpanded = !_schoolExpanded),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.surfaceVariant,
                        )),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                appStrings
                                    .processCardParticipatingEducationalUnits,
                                style: AppTextStyles.titleMedium,
                              ),
                            ),
                            Icon(_schoolExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down),
                          ],
                        ),
                        if (_schoolExpanded) ...[
                          const SizedBox(
                            height: 8,
                          ),
                          ...a.schools.map(
                            (school) => Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    school.name ?? '-',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.onSurfaceVariant,
                                    ),
                                  ),
                                  if (school.city != null) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      school.city!,
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.onSurfaceVariant,
                                      ),
                                    ),
                                  ]
                                ],
                              ),
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                ),

                const SizedBox(
                  height: 16,
                ),

                // Botões
                Row(
                  children: [
                    Expanded(
                      child: EbolsaButton(
                        onPressed: widget.onViewPressed,
                        label: isEdital
                            ? appStrings.noticesTermsViewNoticeAction
                            : appStrings.noticesTermsViewAdditiveTermAction,
                        isOutlined: true,
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: EbolsaButton(
                        label: appStrings.processCardApplyForAScholarshipButton,
                        onPressed: widget.onApplyPressed,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium
              .copyWith(color: AppColors.textSecondaryLight),
        ),
        const SizedBox(
          height: 2,
        ),
        Text(
          value,
          style: AppTextStyles.bodyLarge,
        )
      ],
    );
  }
}
