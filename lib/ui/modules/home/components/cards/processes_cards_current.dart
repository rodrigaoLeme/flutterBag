import 'package:flutter/material.dart';

import '../../../../../main/i18n/app_i18n.dart';
import '../../../../components/ebolsa_text_button.dart';
import '../../../../helpers/themes/themes.dart';
import '../banners/processes_banner_error.dart';
import '../banners/processes_banner_pending_documents_warning.dart';
import '../banners/processes_banner_warning.dart';

final appStrings = AppI18n.current;

enum ProcessSteps {
  initial,
  second,
  third,
  verification,
  fifth,
  completed;

  String get label {
    switch (this) {
      case initial:
        return appStrings.processStepsInitial;
      case second:
        return appStrings.processStepsSecond;
      case third:
        return appStrings.processStepsThird;
      case verification:
        return appStrings.processStepsVerification;
      case fifth:
        return appStrings.processStepsFifth;
      case completed:
        return appStrings.processStepsCompleted;
    }
  }

  Color get color {
    switch (this) {
      case initial:
        return const Color(0xFF45EEFF);
      case second:
        return const Color(0xFFFF9950);
      case third:
        return const Color(0xFFFF9950);
      case verification:
        return const Color(0xFFFF63D8);
      case fifth:
        return const Color(0xFFFF9950);
      case completed:
        return const Color(0xFF7DD6A1);
    }
  }
}

enum ProcessesType {
  renewProcess,
  newProcess;

  String get label {
    switch (this) {
      case renewProcess:
        return appStrings.renewProcess;
      case newProcess:
        return appStrings.newProcess;
    }
  }
}

enum ProcessesBanner {
  warning,
  pending,
  error,
}

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
  final VoidCallback? onViewProcess;
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
    this.onViewProcess,
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
              onPressed: () {},
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
