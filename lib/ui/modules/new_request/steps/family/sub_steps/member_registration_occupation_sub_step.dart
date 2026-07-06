import 'package:flutter/material.dart';

import '../../../../../../main/i18n/app_i18n.dart';
import '../../../../../components/components.dart';
import '../../../../../components/ebolsa_member_card.dart';
import '../../../../../helpers/money_formatter.dart';
import '../../../../../helpers/themes/themes.dart';
import '../member_registration_view_model.dart';
import '../widgets/member_registration_dialogs.dart';

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

  Future<void> _onChildSupportChanged(BuildContext context, int? value) async {
    if (value == null) return;
    if (value == 0) {
      vm.setRecebePensaoAlimenticia(0);
      return;
    }
    vm.setRecebePensaoAlimenticia(1);
    if (vm.pensionIncomeAcknowledged) {
      vm.acknowledgePensionIncome();
      return;
    }
    final acknowledged =
        await MemberRegistrationDialogs.showChildSupportInfoDialog(context);
    if (acknowledged == true) {
      vm.acknowledgePensionIncome();
    } else {
      vm.resetRecebePensaoAlimenticia();
    }
  }

  Future<void> _onInssBenefitChanged(BuildContext context, int? value) async {
    if (value == null) return;
    if (value == 0) {
      vm.setRecebeOutroBeneficioINss(0);
      return;
    }
    vm.setRecebeOutroBeneficioINss(1);
    if (vm.inssBenefitAcknowledged) {
      vm.acknowledgeInssBenefit();
      return;
    }
    final acknowledged =
        await MemberRegistrationDialogs.showInssBenefitInfoDialog(context);
    if (acknowledged == true) {
      vm.acknowledgeInssBenefit();
    } else {
      vm.resetRecebeOutroBeneficioINss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Icon(
              Icons.info_outline_rounded,
              color: AppColors.surfaceContainer,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              AppI18n.current.dataComplementTitle,
              style: AppTextStyles.ebolsaTitleMedium,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 22),
          child: Text(
            AppI18n.current.complementFieldsPlaceholder,
            style: AppTextStyles.bodySmall,
          ),
        ),
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
        EbolsaRadioGroup<int>(
          question: AppI18n.current.childSupportIncomeQuestion,
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
          groupValue: vm.recebePensaoAlimenticia,
          onChanged: (v) => _onChildSupportChanged(context, v),
        ),
        if (vm.showPensionValueField) ...[
          const SizedBox(height: 12),
          SizedBox(
            height: 56,
            child: EbolsaTextField(
              controller: vm.pensionValueController,
              label: AppI18n.current.informValueInReaisLabel,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
          ),
        ],
        const SizedBox(height: 16),
        EbolsaRadioGroup<int>(
          question: AppI18n.current.privatePensionQuestion,
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
          groupValue: vm.recebePrevidenciaPrivada,
          onChanged: (v) {
            if (v != null) vm.setRecebePrevidenciaPrivada(v);
          },
        ),
        if (vm.showPrevidenciaValueField) ...[
          const SizedBox(height: 12),
          SizedBox(
            height: 56,
            child: EbolsaTextField(
              controller: vm.previdenciaValueController,
              label: AppI18n.current.informValueInReaisLabel,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
          ),
        ],
        const SizedBox(height: 16),
        EbolsaRadioGroup<int>(
          question: AppI18n.current.inssBenefitQuestion,
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
          groupValue: vm.recebeOutroBeneficioINSS,
          onChanged: (v) => _onInssBenefitChanged(context, v),
        ),
        if (vm.showInssValueField) ...[
          const SizedBox(height: 12),
          SizedBox(
            height: 56,
            child: EbolsaTextField(
              controller: vm.beneficioValueController,
              label: AppI18n.current.informValueInReaisLabel,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
          ),
        ],
        const SizedBox(height: 16),
      ],
    );
  }
}
