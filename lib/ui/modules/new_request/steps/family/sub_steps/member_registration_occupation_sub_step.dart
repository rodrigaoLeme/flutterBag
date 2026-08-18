import 'package:flutter/material.dart';

import '../../../../../../main/i18n/app_i18n.dart';
import '../../../../../components/components.dart';
import '../../../../../components/ebolsa_member_card.dart';
import '../../../../../helpers/money_formatter.dart';
import '../../../../../helpers/themes/themes.dart';
import '../member_registration_view_model.dart';

class MemberRegistrationOccupationSubStep extends StatelessWidget {
  const MemberRegistrationOccupationSubStep({
    super.key,
    required this.vm,
    required this.onAddOccupation,
    required this.onEditOccupation,
    required this.onDeleteOccupation,
  });

  final MemberRegistrationViewModel vm;
  final Future<void> Function() onAddOccupation;
  final Future<void> Function(int index) onEditOccupation;
  final Future<void> Function(int index) onDeleteOccupation;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.info_outline_rounded,
              color: AppColors.surfaceContainer,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppI18n.current.dataComplementTitle,
                    style: AppTextStyles.ebolsaTitleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppI18n.current.complementFieldsPlaceholder,
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 22),
        EbolsaButton(
          height: 48,
          borderRadius: 8,
          backgroundColor: AppColors.secondaryContainer,
          onPressed: onAddOccupation,
          label: '+ Adicionar ocupação',
          textStyle: AppTextStyles.ebolsaTitleMedium.copyWith(
            color: AppColors.onPrimaryContainer,
          ),
        ),
        if (vm.addedOccupations.isNotEmpty)
          for (var i = 0; i < vm.addedOccupations.length; i++)
            EbolsaMemberCard(
              headerTitle: MoneyFormatter.format(
                vm.addedOccupations[i]['monthlyIncome'] ??
                    vm.addedOccupations[i]['headerTitle'],
              ),
              title: vm.addedOccupations[i]['occupation']?.toString() ?? '',
              subtitle: vm.addedOccupations[i]['occupationDetails'] != null
                  ? vm.addedOccupations[i]['occupationDetails']['function']
                          ?.toString() ??
                      ''
                  : vm.addedOccupations[i]['subtitle']?.toString() ?? '',
              content: vm.addedOccupations[i]['company'] != null
                  ? [Text(vm.addedOccupations[i]['company'].toString())]
                  : const [],
              onEdit: () => onEditOccupation(i),
              onDelete: () => onDeleteOccupation(i),
            ),
        const SizedBox(height: 16),
      ],
    );
  }
}
