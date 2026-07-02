import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../domain/entities/process_enums.dart';
import '../../../../../main/i18n/app_i18n.dart';
import '../../../../components/components.dart';
import '../../../../helpers/themes/themes.dart';

final appStrings = AppI18n.current;

class ProcessCardResult extends StatelessWidget {
  final String studentName;
  final String schoolUnit;
  final String course;
  final String processCode;
  final ResultStatus result;
  final RegistrationStatus enrollmentStatus;
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
            padding: const EdgeInsets.only(bottom: 16, top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(
                  fit: FlexFit.loose,
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
                Flexible(
                  fit: FlexFit.loose,
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
  final ResultStatus result;

  const _ResultBadge({required this.result});

  @override
  Widget build(BuildContext context) {
    final Color colorText = (result.value == 4)
        ? Theme.of(context).colorScheme.surface
        : Theme.of(context).colorScheme.onSurface;
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
              color: colorText,
            ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _EnrollmentBadge extends StatelessWidget {
  final RegistrationStatus status;

  const _EnrollmentBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final String statusIcon = _getIcon(status);
    final Color colorText = (status.value < 5)
        ? Theme.of(context).colorScheme.onSurface
        : Theme.of(context).colorScheme.surface;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: status.color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: SvgPicture.asset(
              statusIcon,
              color: colorText,
              width: 14,
            ),
          ),
          Text(
            status.label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: colorText,
                  fontWeight: FontWeight.w500,
                ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  String _getIcon(RegistrationStatus status) {
    switch (status) {
      case RegistrationStatus.noRegistration:
        return AppIcons.noneIcon;
      case RegistrationStatus.reserveSpot:
        return AppIcons.exclamationIcon;
      case RegistrationStatus.completed:
      case RegistrationStatus.registered:
        return AppIcons.checkIcon;
      case RegistrationStatus.locked:
      case RegistrationStatus.withdrawal:
      case RegistrationStatus.canceled:
        return AppIcons.blockedIcon;
      case RegistrationStatus.awaitingApproval:
        return AppIcons.hourGlassIcon;
      case RegistrationStatus.transferred:
        return AppIcons.transferIcon;
    }
  }
}
