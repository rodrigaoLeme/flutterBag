import 'package:flutter/material.dart';

import '../../../../../../main/i18n/app_i18n.dart';
import '../../../../../components/components.dart';
import '../member_registration_view_model.dart';

class MemberRegistrationOtherIncomeSubStep extends StatelessWidget {
  final MemberRegistrationViewModel vm;

  const MemberRegistrationOtherIncomeSubStep({
    super.key,
    required this.vm,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
EbolsaRadioGroup<int>(
                          question:
                              AppI18n.current.rentedPropertyIncomeQuestion,
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
                          groupValue: vm.recebeValorImovelAlugado,
                          onChanged: (v) {
                            if (v != null) vm.setRecebeValorImovelAlugado(v);
                          },
                        ),
                        if (vm.recebeValorImovelAlugado == 1) ...[
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 56,
                            child: EbolsaTextField(
                              controller: vm.imovelAlugadoValueController,
                              label: AppI18n.current.informValueInReaisLabel,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                        EbolsaRadioGroup<int>(
                          question: AppI18n.current.financialHelpQuestion,
                          options: [
                            RadioOption(
                              label: AppI18n.current.financialHelpNone,
                              value: 0,
                            ),
                            RadioOption(
                              label: AppI18n.current.financialHelpFamily,
                              value: 1,
                            ),
                            RadioOption(
                              label: AppI18n.current.financialHelpOther,
                              value: 2,
                            ),
                          ],
                          groupValue: vm.ajudaFinanceira,
                          onChanged: (v) {
                            if (v != null) vm.setAjudaFinanceira(v);
                          },
                        ),
                        if (vm.ajudaFinanceira == 1) ...[
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 56,
                            child: EbolsaTextField(
                              controller: vm.ajudaFamiliarValueController,
                              label: AppI18n.current.informValueInReaisLabel,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                            ),
                          ),
                        ],
                        if (vm.ajudaFinanceira == 2) ...[
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 56,
                            child: EbolsaTextField(
                              controller: vm.ajudaOutroDeQuemController,
                              label: AppI18n.current.financialHelpFromWhomLabel,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 56,
                            child: EbolsaTextField(
                              controller: vm.ajudaOutroValueController,
                              label: AppI18n.current.informValueInReaisLabel,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                        EbolsaRadioGroup<int>(
                          question: AppI18n.current.governmentProgramQuestion,
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
                          groupValue: vm.beneficiarioProgramaGoverno,
                          onChanged: (v) {
                            if (v != null) vm.setBeneficiarioProgramaGoverno(v);
                          },
                        ),
                        if (vm.beneficiarioProgramaGoverno == 1) ...[
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 56,
                            child: EbolsaTextField(
                              controller: vm.programaGovernoController,
                              label:
                                  AppI18n.current.informGovernmentProgramLabel,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 56,
                            child: EbolsaTextField(
                              controller: vm.programaGovernoValueController,
                              label: AppI18n.current.informValueInReaisLabel,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                            ),
                          ),
                        ],
      ],
    );
  }
}
