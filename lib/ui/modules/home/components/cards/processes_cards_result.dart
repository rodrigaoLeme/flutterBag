import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../main/i18n/app_i18n.dart';
import '../../../../components/components.dart';
import '../../../../helpers/themes/themes.dart';

final appStrings = AppI18n.current;

enum ProcessResult {
  approved,
  disqualified,
  underReview,
  pending;

  String get label {
    switch (this) {
      case approved:
        return appStrings.approved;
      case disqualified:
        return appStrings.disqualified;
      case underReview:
        return appStrings.underReview;
      case pending:
        return appStrings.pending;
    }
  }

  Color get color {
    switch (this) {
      case approved:
        return const Color(0xFF4CAF50);
      case disqualified:
        return const Color(0xFFFF9950);
      case underReview:
        return const Color(0xFF2196F3);
      case pending:
        return const Color(0xFF9E9E9E);
    }
  }
}

enum EnrollmentStatus {
  withoutRegistration,
  registered,
  inProcess;

  String get label {
    switch (this) {
      case withoutRegistration:
        return appStrings.withoutRegistration;
      case registered:
        return appStrings.registered;
      case inProcess:
        return appStrings.inProcess;
    }
  }
}

class ProcessCardResult extends StatelessWidget {
  final String studentName;
  final String schoolUnit;
  final String course;
  final String processCode;
  final ProcessResult result;
  final EnrollmentStatus enrollmentStatus;
  final VoidCallback? onViewProcess;

  const ProcessCardResult({
    super.key,
    required this.studentName,
    required this.schoolUnit,
    required this.course,
    required this.processCode,
    required this.result,
    required this.enrollmentStatus,
    this.onViewProcess,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
            child: Center(
              child: Text(
                studentName,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
          const Divider(
            height: 1,
            endIndent: 16,
            indent: 16,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 32, right: 32, top: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoRow(
                  label: appStrings.schoolUnit,
                  value: schoolUnit,
                ),
                const SizedBox(height: 12),
                _InfoRow(
                  label: appStrings.course,
                  value: course,
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              color: AppColors.outlineVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appStrings.processCode,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondaryLight,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        processCode,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: EbolsaIconButton(
                    onPressed: () {},
                    label: appStrings.viewButton,
                    iconPath: AppIcons.pdfFileIcon,
                    isOutlined: true,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Divider(
            height: 1,
            endIndent: 16,
            indent: 16,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        appStrings.result,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondaryLight,
                            ),
                      ),
                      const SizedBox(height: 8),
                      _ResultBadge(result: result),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        appStrings.enrollmentStatus,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondaryLight,
                            ),
                      ),
                      const SizedBox(height: 8),
                      _EnrollmentBadge(status: enrollmentStatus),
                    ],
                  ),
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

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondaryLight,
              ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
}

class _ResultBadge extends StatelessWidget {
  final ProcessResult result;

  const _ResultBadge({required this.result});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: result.color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        result.label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

class _EnrollmentBadge extends StatelessWidget {
  final EnrollmentStatus status;

  const _EnrollmentBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Color(0xFFE0E2EC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (status == EnrollmentStatus.withoutRegistration)
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: SvgPicture.asset(
                AppIcons.noneIcon,
              ),
            ),
          Text(
            status.label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.textSecondaryLight,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}
