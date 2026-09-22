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
        const SizedBox(height: 20),
        if (vm.addedOccupations.isNotEmpty)
          for (var i = 0; i < vm.addedOccupations.length; i++)
            EbolsaMemberCard(
              headerTitle: MoneyFormatter.format(
                vm.addedOccupations[i]['monthlyIncome'] ??
                    vm.addedOccupations[i]['headerTitle'],
              ),
              title: vm.addedOccupations[i]['occupation']?.toString() ?? '',
              subtitle: vm.addedOccupations[i]['occupationDetails'].isNotEmpty
                  ? vm.addedOccupations[i]['occupationDetails']['function']
                      ?.toString()
                  : null,
              content: showContent(
                vm.addedOccupations[i],
              ),
              onEdit: () => onEditOccupation(i),
              onDelete: () => onDeleteOccupation(i),
            ),
        const SizedBox(height: 16),
      ],
    );
  }

  List<Text> showContent(Map occupationDetails) {
    final typeId = (occupationDetails['occupationTypeId'] ??
        occupationDetails['ocupationTypeId'] ??
        '') as String;
    final details = (occupationDetails['occupationDetails'] as Map?) ?? {};

    if (details.isEmpty) return [];

    if (occupationDetails.isEmpty) {
      return [];
    }

    // Proprietário
    if (typeId == '7c8efd3f-c5b1-449f-a2c2-cef814cb296e') {
      return [
        Text('${occupationDetails['Porte da empresa'] ?? ''}',
            style: AppTextStyles.labelMedium),
        Text('CNPJ: ${occupationDetails['CNPJ'] ?? ''}',
            style: AppTextStyles.labelMedium),
        Text('Função/Atuação: ${occupationDetails['Função/Atuação'] ?? ''}',
            style: AppTextStyles.labelMedium),
      ];
    }

    // Autônomo
    if (typeId == '54b67b6a-7759-49a3-9df3-c2f205bb8960') {
      return [
        Text('Função: ${occupationDetails['Função'] ?? ''}',
            style: AppTextStyles.labelMedium),
      ];
    }

    // Informal
    if (typeId == '9df23f2f-c523-4ac3-9857-e891cb6f24d8') {
      return [
        Text('Função: ${occupationDetails['Função'] ?? ''}',
            style: AppTextStyles.labelMedium),
      ];
    }

    // Assalariado
    if (typeId == '27e77bb7-387e-4b3a-819e-d34518a91908') {
      return [
        Text('${occupationDetails['occupationDetails']['Empresa'] ?? ''}',
            style: AppTextStyles.labelMedium),
        Text(
            'Função: ${occupationDetails['occupationDetails']['Função'] ?? ''}',
            style: AppTextStyles.labelMedium),
      ];
    }

    // Desempregado
    if (typeId == '799d77b8-435e-4d37-bf1d-e3d68916cf4c') {
      if (occupationDetails['Recebe seguro desemprego?'] == 'Sim') {
        return [
          Text('Recebe seguro desemprego', style: AppTextStyles.labelMedium)
        ];
      } else {
        return [
          Text('Não recebe seguro desemprego', style: AppTextStyles.labelMedium)
        ];
      }
    }

    return [];
  }
}
