import 'package:flutter/material.dart';

import '../../../../../../main/i18n/app_i18n.dart';
import '../../../../../helpers/money_formatter.dart';
import '../../../../../helpers/themes/themes.dart';
import '../member_registration_view_model.dart';

class MemberRegistrationSummarySubStep extends StatelessWidget {
  const MemberRegistrationSummarySubStep({super.key, required this.vm});

  final MemberRegistrationViewModel vm;

  @override
  Widget build(BuildContext context) {
    final i18n = AppI18n.current;
    final data = vm.summaryData;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SummaryRow(
          label: i18n.grossFamilyIncomeLabel,
          value: MoneyFormatter.format(data.grossIncome),
        ),
        _SummaryRow(
          label: i18n.incomeDependentsLabel,
          value: data.incomeDependents.toString(),
        ),
        _SummaryRow(
          label: i18n.perCapitaIncomeLabel,
          value: MoneyFormatter.format(data.perCapitaIncome),
        ),
        _SummaryRow(
          label: i18n.minimumWageLabel,
          value: MoneyFormatter.format(data.minimumWage),
        ),
        _SummaryRow(
          label: i18n.perCapitaTimesMinimumWageLabel,
          value: data.salaryRatioLabel,
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(label, style: AppTextStyles.bodyLarge)),
          const SizedBox(width: 12),
          Text(
            value,
            style: AppTextStyles.titleSmall,
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }
}
