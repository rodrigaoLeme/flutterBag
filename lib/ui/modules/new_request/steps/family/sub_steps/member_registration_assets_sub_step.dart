import 'package:flutter/material.dart';

import '../../../../../../main/i18n/app_i18n.dart';
import '../../../../../components/components.dart';
import '../../../../../components/ebolsa_member_card.dart';
import '../../../../../helpers/money_formatter.dart';
import '../../../../../helpers/themes/themes.dart';
import '../member_registration_view_model.dart';

class MemberRegistrationAssetsSubStep extends StatelessWidget {
  final MemberRegistrationViewModel vm;
  final Future<void> Function({int? editIndex}) onOpenProperty;
  final Future<void> Function({int? editIndex}) onOpenInvestment;
  final Future<void> Function({int? editIndex}) onOpenVehicle;
  final void Function(int index) onDeleteProperty;
  final void Function(int index) onDeleteInvestment;
  final void Function(int index) onDeleteVehicle;

  const MemberRegistrationAssetsSubStep({
    super.key,
    required this.vm,
    required this.onOpenProperty,
    required this.onOpenInvestment,
    required this.onOpenVehicle,
    required this.onDeleteProperty,
    required this.onDeleteInvestment,
    required this.onDeleteVehicle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        EbolsaRadioGroup<int>(
          question: AppI18n.current.ownsPropertyQuestion,
          options: [
            RadioOption(
              label: AppI18n.current.answerNo,
              value: 0,
            ),
            RadioOption(
              label: AppI18n.current.answerYes,
              value: 1,
            ),
          ],
          groupValue: vm.possuiImovelProprio,
          onChanged: (v) {
            if (v != null) vm.setPossuiImovelProprio(v);
          },
        ),
        if (vm.possuiImovelProprio == 1) ...[
          const SizedBox(height: 16),
          EbolsaButton(
            height: 48,
            borderRadius: 8,
            backgroundColor: AppColors.secondaryContainer,
            onPressed: () => onOpenProperty(),
            label: AppI18n.current.addPropertyAction,
            textStyle: AppTextStyles.ebolsaTitleMedium.copyWith(
              color: AppColors.onPrimaryContainer,
            ),
          ),
          if (vm.addedProperties.isNotEmpty) ...[
            for (var i = 0; i < vm.addedProperties.length; i++) ...[
              EbolsaMemberCard(
                title: vm.addedProperties[i]['type']?.toString() ?? '',
                content: [
                  Text(
                    '${AppI18n.current.propertyFinancingValueLabel} '
                    '${MoneyFormatter.format(vm.addedProperties[i]['installmentValue'])}',
                    style: AppTextStyles.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${AppI18n.current.propertyAssetValueDisplayLabel} '
                    '${MoneyFormatter.format(vm.addedProperties[i]['assetValue'])}',
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
                onEdit: () => onOpenProperty(editIndex: i),
                onDelete: () => onDeleteProperty(i),
              ),
            ],
          ],
        ],
        const SizedBox(height: 16),
        EbolsaRadioGroup<int>(
          question: AppI18n.current.ownsFinancialInvestmentQuestion,
          options: [
            RadioOption(
              label: AppI18n.current.answerNo,
              value: 0,
            ),
            RadioOption(
              label: AppI18n.current.answerYes,
              value: 1,
            ),
          ],
          groupValue: vm.possuiInvestimentoFinanceiro,
          onChanged: (v) {
            if (v != null) vm.setPossuiInvestimentoFinanceiro(v);
          },
        ),
        if (vm.possuiInvestimentoFinanceiro == 1) ...[
          const SizedBox(height: 16),
          EbolsaButton(
            height: 48,
            borderRadius: 8,
            backgroundColor: AppColors.secondaryContainer,
            onPressed: () => onOpenInvestment(),
            label: AppI18n.current.addInvestmentAction,
            textStyle: AppTextStyles.ebolsaTitleMedium.copyWith(
              color: AppColors.onPrimaryContainer,
            ),
          ),
          if (vm.addedInvestments.isNotEmpty) ...[
            for (var i = 0; i < vm.addedInvestments.length; i++) ...[
              EbolsaMemberCard(
                title: vm.addedInvestments[i]['type']?.toString() ?? '',
                content: [
                  Text(
                    '${AppI18n.current.valueDisplayLabel} '
                    '${MoneyFormatter.format(vm.addedInvestments[i]['value'])}',
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
                onEdit: () => onOpenInvestment(editIndex: i),
                onDelete: () => onDeleteInvestment(i),
              ),
            ],
          ],
        ],
        const SizedBox(height: 16),
        EbolsaRadioGroup<int>(
          question: AppI18n.current.ownsVehicleQuestion,
          subtitle: AppI18n.current.ownsVehicleSubtitle,
          options: [
            RadioOption(
              label: AppI18n.current.answerNo,
              value: 0,
            ),
            RadioOption(
              label: AppI18n.current.answerYes,
              value: 1,
            ),
          ],
          groupValue: vm.possuiVeiculo,
          onChanged: (v) {
            if (v != null) vm.setPossuiVeiculo(v);
          },
        ),
        if (vm.possuiVeiculo == 1) ...[
          const SizedBox(height: 16),
          EbolsaButton(
            height: 48,
            borderRadius: 8,
            backgroundColor: AppColors.secondaryContainer,
            onPressed: () => onOpenVehicle(),
            label: AppI18n.current.addVehicleAction,
            textStyle: AppTextStyles.ebolsaTitleMedium.copyWith(
              color: AppColors.onPrimaryContainer,
            ),
          ),
          if (vm.addedVehicles.isNotEmpty) ...[
            for (var i = 0; i < vm.addedVehicles.length; i++) ...[
              EbolsaMemberCard(
                title:
                    '${vm.addedVehicles[i]['brand']} ${vm.addedVehicles[i]['model']}',
                content: [
                  Text(
                    '${AppI18n.current.vehicleYearDisplayLabel} '
                    '${vm.addedVehicles[i]['year']}',
                    style: AppTextStyles.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${AppI18n.current.vehicleInstallmentDisplayLabel} '
                    '${MoneyFormatter.format(vm.addedVehicles[i]['installmentValue'])}',
                    style: AppTextStyles.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${AppI18n.current.propertyAssetValueDisplayLabel} '
                    '${MoneyFormatter.format(vm.addedVehicles[i]['assetValue'])}',
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
                onEdit: () => onOpenVehicle(editIndex: i),
                onDelete: () => onDeleteVehicle(i),
              ),
            ],
          ],
        ],
      ],
    );
  }
}
