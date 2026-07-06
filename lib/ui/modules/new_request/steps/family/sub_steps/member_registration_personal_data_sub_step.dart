import 'package:flutter/material.dart';

import '../../../../../../main/i18n/app_i18n.dart';
import '../../../../../components/components.dart';
import '../../../../../helpers/themes/themes.dart';
import '../member_registration_view_model.dart';

class MemberRegistrationPersonalDataSubStep extends StatelessWidget {
  final MemberRegistrationViewModel vm;
  final VoidCallback onSelectDate;
  final VoidCallback onOpenNationality;
  final VoidCallback onOpenPcd;

  const MemberRegistrationPersonalDataSubStep({
    super.key,
    required this.vm,
    required this.onSelectDate,
    required this.onOpenNationality,
    required this.onOpenPcd,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
SizedBox(height: 8),
                        SizedBox(
                          height: 56,
                          child: EbolsaTextField(
                              controller: vm.cpfController,
                              label: AppI18n.current.authCpfLabel),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 56,
                          child: EbolsaTextField(
                              controller: vm.nameController,
                              label:
                                  AppI18n.current.createAccountFullNameLabel),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 56,
                                child: GestureDetector(
                                  onTap: onSelectDate,
                                  child: AbsorbPointer(
                                    child: EbolsaTextField(
                                      controller: vm.dobController,
                                      label: AppI18n.current.dobLabel,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: SizedBox(
                                height: 56,
                                child: DropdownButtonFormField<String>(
                                  initialValue: vm.selectedGender,
                                  style: AppTextStyles.bodyMedium
                                      .copyWith(color: AppColors.onSurface),
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  decoration: InputDecoration(
                                    hintText: AppI18n.current.genderLabel,
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 16),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  items: vm.genderOptions
                                      .map(
                                        (g) => DropdownMenuItem(
                                          value: g,
                                          child: Text(
                                            g,
                                            style: AppTextStyles.bodyMedium,
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (v) => vm.setSelectedGender(v),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 56,
                                child: DropdownButtonFormField<String>(
                                  initialValue: vm.selectedResponsible,
                                  style: AppTextStyles.bodyMedium
                                      .copyWith(color: AppColors.onSurface),
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  decoration: InputDecoration(
                                    hintText: AppI18n.current.responsibleLabel,
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 16),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  items: vm.responsibleOptions
                                      .map(
                                        (r) => DropdownMenuItem(
                                          value: r,
                                          child: Text(
                                            r,
                                            style: AppTextStyles.bodyMedium,
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: vm.setSelectedResponsible,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: SizedBox(
                                height: 56,
                                child: DropdownButtonFormField<MaritalStatus>(
                                  initialValue: vm.maritalStatus,
                                  style: AppTextStyles.bodyMedium
                                      .copyWith(color: AppColors.onSurface),
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  decoration: InputDecoration(
                                    hintText:
                                        AppI18n.current.maritalStatusLabel,
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 16),
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  items: vm.maritalOptions
                                      .map((m) => DropdownMenuItem(
                                          value: m,
                                          child: Text(vm.maritalDisplay(m),
                                              style: AppTextStyles.bodyMedium)))
                                      .toList(),
                                  onChanged: (v) => vm.setMarital(v),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // se o estado civil for viuva deve aparecer esse campo abaixo para informar se recebe pensão
                        if (vm.showReceivesPension) ...[
                          const SizedBox(height: 16),
                          EbolsaRadioGroup<int>(
                            question: AppI18n.current.receivesPensionQuestion,
                            options: [
                              RadioOption(
                                  label: AppI18n.current.answerNo, value: 0),
                              RadioOption(
                                  label: AppI18n.current.answerYes, value: 1),
                            ],
                            groupValue: vm.recebePensao,
                            onChanged: (v) => vm.setRecebePensao(v),
                          ),
                          // se ele responder que sim, deve mostrar o campo para inserir se é aposentado(a)?
                          if (vm.showIsRetired) ...[
                            const SizedBox(height: 16),
                            EbolsaRadioGroup<int>(
                              question: AppI18n.current.isRetiredQuestion,
                              options: [
                                RadioOption(
                                    label: AppI18n.current.answerNo, value: 0),
                                RadioOption(
                                    label: AppI18n.current.answerYes, value: 1),
                              ],
                              groupValue: vm.aposentado,
                              onChanged: (v) => vm.setAposentado(v),
                            ),
                          ]
                        ],
                        const SizedBox(height: 16),
                        EbolsaRadioGroup<int>(
                          question:
                              AppI18n.current.willApplyScholarshipQuestion,
                          options: [
                            RadioOption(
                                label: AppI18n.current.answerNo, value: 0),
                            RadioOption(
                                label: AppI18n.current.answerYes, value: 1),
                          ],
                          groupValue: vm.seraCandidato,
                          onChanged: (v) => vm.setSeraCandidato(v),
                        ),
                        //Se ele responder sim, mostrar o campo para selecionar a nacionalidade
                        if (vm.seraCandidato == 1) ...[
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 56,
                            child: InkWell(
                              onTap: onOpenNationality,
                              borderRadius: BorderRadius.circular(12),
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  hintText: AppI18n.current.nationalityLabel,
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 16),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  suffixIcon:
                                      const Icon(Icons.keyboard_arrow_down),
                                ),
                                child: Text(
                                  vm.nacionalityController.text.isNotEmpty
                                      ? vm.nacionalityController.text
                                      : AppI18n.current.nationalityLabel,
                                  style: vm.nacionalityController.text.isEmpty
                                      ? AppTextStyles.bodyMedium.copyWith(
                                          color: AppColors.onSurface
                                              .withValues(alpha: 0.6))
                                      : AppTextStyles.bodyMedium,
                                ),
                              ),
                            ),
                          ),
                        ],
                        // se ele for nacionalidade estrangeira deve mostrar o campo abaixo
                        if ((vm.nacionalityController.text
                            .trim()
                            .isNotEmpty)) ...[
                          const SizedBox(height: 16),
                          EbolsaRadioGroup<int>(
                            question: AppI18n.current.naturalizedQuestion,
                            options: [
                              RadioOption(
                                  label: AppI18n.current.answerNo, value: 0),
                              RadioOption(
                                  label: AppI18n.current.answerYes, value: 1),
                            ],
                            groupValue: vm.naturalizado,
                            onChanged: (v) => vm.setNaturalizado(v),
                          ),
                          //se ele responder que não é naturalizado, deve mostrar o campo abaixo de alerta EbolsaImportantBanner
                          if (vm.naturalizado == 0) ...[
                            EbolsaImportantBanner(
                              title: AppI18n.current.concessionBannerTitle,
                              message: AppI18n.current.concessionBannerMessage,
                            ),
                          ]
                        ],
                        const SizedBox(height: 12),
                        EbolsaRadioGroup<int>(
                          question: AppI18n.current.hasCINQuestion,
                          options: [
                            RadioOption(
                                label: AppI18n.current.answerNo, value: 0),
                            RadioOption(
                                label: AppI18n.current.answerYes, value: 1),
                          ],
                          groupValue: vm.possuiCIN,
                          onChanged: (v) => vm.setPossuiCIN(v),
                        ),
                        // se a resposta for sim, mostrar os campos abaixo para inserir o número do CIN e o órgão emissor
                        if (vm.possuiCIN == 1) ...[
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 56,
                                  child: EbolsaTextField(
                                      controller: vm.rgController,
                                      label: AppI18n.current.rgLabel),
                                ),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                child: SizedBox(
                                  height: 56,
                                  child: EbolsaTextField(
                                      controller: vm.orgaoController,
                                      label: AppI18n.current.issuingOrgLabel),
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 12),
                        EbolsaRadioGroup<int>(
                          question: AppI18n.current.hasCadunicoQuestion,
                          options: [
                            RadioOption(
                                label: AppI18n.current.answerNo, value: 0),
                            RadioOption(
                                label: AppI18n.current.answerYes, value: 1),
                          ],
                          groupValue: vm.cadunicoValue,
                          onChanged: (v) => vm.setCadunicoValue(v),
                        ),
                        //se a responda for sim mostrar o campo para inserir o número do NIS (Cadúnico)
                        if (vm.cadunicoValue == 1) ...[
                          SizedBox(
                            height: 56,
                            child: EbolsaTextField(
                              controller: vm.nisController,
                              label: AppI18n.current.nisLabel,
                            ),
                          ),
                        ],
                        const SizedBox(height: 12),
                        EbolsaRadioGroup<int>(
                          question: 'Transtorno do Espectro Autista(TEA)?',
                          options: [
                            RadioOption(
                                label: AppI18n.current.answerNo, value: 0),
                            RadioOption(
                                label: AppI18n.current.answerYes, value: 1),
                          ],
                          groupValue: vm.espectro,
                          onChanged: (v) => vm.setEspectro(v),
                        ),
                        const SizedBox(height: 12),
                        EbolsaRadioGroup<int>(
                          question: 'Altas Habilidades ou Superdotação?',
                          options: [
                            RadioOption(
                                label: AppI18n.current.answerNo, value: 0),
                            RadioOption(
                                label: AppI18n.current.answerYes, value: 1),
                          ],
                          groupValue: vm.superdotacao,
                          onChanged: (v) => vm.setSuperdotacao(v),
                        ),
                        const SizedBox(height: 12),
                        EbolsaRadioGroup<int>(
                          question: AppI18n.current.hasChronicDiseaseQuestion,
                          options: [
                            RadioOption(
                                label: AppI18n.current.answerNo, value: 0),
                            RadioOption(
                                label: AppI18n.current.answerYes, value: 1),
                          ],
                          groupValue: vm.possuiDoenca,
                          onChanged: (v) => vm.setPossuiDoenca(v),
                        ),
                        // se a resposta for sim, mostrar o campo para inserir o tipo de doença
                        if (vm.possuiDoenca == 1) ...[
                          SizedBox(
                            height: 56,
                            child: EbolsaTextField(
                              controller: vm.tipoDoencaController,
                              label: AppI18n.current.diseaseTypeLabel,
                            ),
                          ),
                        ],
                        // O dropdown de PcD deve aparecer sempre (label + campo no estilo)
                        const SizedBox(height: 8),
                        Text(
                          AppI18n.current.pcdLabel,
                          style: AppTextStyles.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 56,
                          child: InkWell(
                            onTap: onOpenPcd,
                            borderRadius: BorderRadius.circular(12),
                            child: InputDecorator(
                              decoration: InputDecoration(
                                hintText: 'Selecione',
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 16),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                suffixIcon:
                                    const Icon(Icons.keyboard_arrow_down),
                              ),
                              child: Text(
                                vm.selectedPcd ?? 'Selecione',
                                style: vm.selectedPcd == null
                                    ? AppTextStyles.bodyMedium.copyWith(
                                        color: AppColors.onSurface
                                            .withValues(alpha: 0.6))
                                    : AppTextStyles.bodyMedium,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        EbolsaRadioGroup<int>(
                          question: AppI18n.current.irpfConditionLabel,
                          options: [
                            RadioOption(
                                label: AppI18n.current.irpfDeclarante,
                                value: 0),
                            RadioOption(
                                label: AppI18n.current.irpfIsento, value: 1),
                          ],
                          groupValue: vm.irpfCondition,
                          onChanged: (v) => vm.setIrpfCondition(v),
                        ),
                        const SizedBox(height: 12),
                        EbolsaRadioGroup<int>(
                          question: AppI18n.current.declaredThisYearQuestion,
                          options: [
                            RadioOption(
                                label: AppI18n.current.answerNo, value: 0),
                            RadioOption(
                                label: AppI18n.current.answerYes, value: 1),
                          ],
                          groupValue: vm.declarouEsseAno,
                          onChanged: (v) => vm.setDeclarouEsseAno(v),
                        ),
                        const SizedBox(height: 12),
                        EbolsaRadioGroup<int>(
                          question: AppI18n.current.hasWorkCardQuestion,
                          options: [
                            RadioOption(
                                label: AppI18n.current.answerNo, value: 0),
                            RadioOption(
                                label: AppI18n.current.answerYes, value: 1),
                          ],
                          groupValue: vm.temCarteira,
                          onChanged: (v) => vm.setTemCarteira(v),
                        ),
                        const SizedBox(height: 12),
                        EbolsaRadioGroup<int>(
                          question: AppI18n.current.ruralWorkerQuestion,
                          options: [
                            RadioOption(
                                label: AppI18n.current.answerNo, value: 0),
                            RadioOption(
                                label: AppI18n.current.answerYes, value: 1),
                          ],
                          groupValue: vm.trabalhadorRural,
                          onChanged: (v) => vm.setTrabalhadorRural(v),
                        ),
      ],
    );
  }
}
