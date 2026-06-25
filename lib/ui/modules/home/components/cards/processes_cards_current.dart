import 'package:flutter/material.dart';

import '../../../../../domain/entities/process_enums.dart';
import '../../../../../main/i18n/app_i18n.dart';
import '../../../../components/ebolsa_text_button.dart';
import '../../../../helpers/themes/themes.dart';
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
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appStrings.administrativeRegion,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppColors.textSecondaryLight,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    administrativeRegion,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondaryLight,
                          fontWeight: FontWeight.w500,
                        ),
                  )
                ],
              ),
              SizedBox(
                width: 56,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appStrings.processCardNotice,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppColors.textSecondaryLight,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    notice,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondaryLight,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appStrings.processCardLevel,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppColors.textSecondaryLight,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    level,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondaryLight,
                          fontWeight: FontWeight.w500,
                        ),
                  )
                ],
              ),
              SizedBox(
                width: 76,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appStrings.processCardScholarshipType,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppColors.textSecondaryLight,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    scholarshipType,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondaryLight,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appStrings.processCardProcessType,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppColors.textSecondaryLight,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    processType.label,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondaryLight,
                          fontWeight: FontWeight.w500,
                        ),
                  )
                ],
              ),
              SizedBox(
                width: 56,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appStrings.processCardStep,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppColors.textSecondaryLight,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  _ResultLevel(
                    step: step,
                  )
                ],
              )
            ],
          ),
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

class _ResultLevel extends StatelessWidget {
  final ProcessSteps step;

  const _ResultLevel({required this.step});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: step.color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        step.label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
