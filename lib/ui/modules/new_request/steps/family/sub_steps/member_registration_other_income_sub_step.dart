import 'package:flutter/material.dart';

import '../../../../../../main/i18n/app_i18n.dart';
import '../../../../../components/components.dart';
import '../../../../../components/ebolsa_member_card.dart';
import '../../../../../helpers/money_formatter.dart';
import '../../../../../helpers/themes/themes.dart';
import '../member_registration_view_model.dart';

class MemberRegistrationOtherIncomeSubStep extends StatelessWidget {
  final MemberRegistrationViewModel vm;
  final Future<void> Function() onAddOtherIncome;
  final Future<void> Function(int index) onEditOtherIncome;
  final Future<void> Function(int index) onDeleteOtherIncome;
  final Future<bool> Function() onConfirmNoOtherIncome;

  const MemberRegistrationOtherIncomeSubStep({
    super.key,
    required this.vm,
    required this.onAddOtherIncome,
    required this.onEditOtherIncome,
    required this.onDeleteOtherIncome,
    required this.onConfirmNoOtherIncome,
  });

  @override
  Widget build(BuildContext context) {
    final i18n = AppI18n.current;
    final declaredNoOtherIncome = vm.possuiOutraFonteRenda == 0;

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
                    i18n.otherIncomeSourcesInfoTitle,
                    style: AppTextStyles.ebolsaTitleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    i18n.otherIncomeSourcesInfoDescription,
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        if (declaredNoOtherIncome)
          _NoOtherIncomeDeclarationCard(
            message: i18n.otherIncomeNoSourcesDeclaredMessage,
            undoLabel: i18n.undoAction,
            onUndo: vm.clearOtherIncomeSelection,
          )
        else ...[
          EbolsaRadioGroup<int>(
            question:
                i18n.otherIncomeHasOtherSourceQuestion(vm.memberFirstName),
            options: [
              RadioOption(label: i18n.answerYes, value: 1),
              RadioOption(label: i18n.answerNo, value: 0),
            ],
            groupValue: vm.possuiOutraFonteRenda,
            onChanged: (v) async {
              if (v == null) return;
              if (v == 1) {
                vm.setPossuiOutraFonteRenda(1);
                await onAddOtherIncome();
                return;
              }

              final confirmed = await onConfirmNoOtherIncome();
              if (confirmed) {
                vm.setPossuiOutraFonteRenda(0);
              }
            },
          ),
          if (vm.possuiOutraFonteRenda == 1) ...[
            const SizedBox(height: 22),
            EbolsaButton(
              height: 48,
              borderRadius: 8,
              backgroundColor: AppColors.secondaryContainer,
              onPressed: onAddOtherIncome,
              label: i18n.addOtherIncomeSource,
              icon: Icons.add,
              textStyle: AppTextStyles.ebolsaTitleMedium.copyWith(
                color: AppColors.onPrimaryContainer,
              ),
            ),
            if (vm.addedOtherIncomes.isNotEmpty)
              for (var i = 0; i < vm.addedOtherIncomes.length; i++)
                EbolsaMemberCard(
                  headerTitle: MoneyFormatter.format(
                    vm.addedOtherIncomes[i]['monthlyIncome'],
                  ),
                  title: vm.addedOtherIncomes[i]['type']?.toString() ?? '',
                  subtitle: vm.addedOtherIncomes[i]['description']?.toString(),
                  content: const [],
                  onEdit: () => onEditOtherIncome(i),
                  onDelete: () => onDeleteOtherIncome(i),
                ),
          ],
        ],
      ],
    );
  }
}

class _NoOtherIncomeDeclarationCard extends StatelessWidget {
  const _NoOtherIncomeDeclarationCard({
    required this.message,
    required this.undoLabel,
    required this.onUndo,
  });

  final String message;
  final String undoLabel;
  final VoidCallback onUndo;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.successLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline_rounded,
            color: AppColors.successDark,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.successDark,
              ),
            ),
          ),
          const SizedBox(width: 8),
          OutlinedButton(
            onPressed: onUndo,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.warningLight,
              side: const BorderSide(color: AppColors.warningLight),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              undoLabel,
              style: AppTextStyles.titleSmall.copyWith(
                color: AppColors.warningLight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
