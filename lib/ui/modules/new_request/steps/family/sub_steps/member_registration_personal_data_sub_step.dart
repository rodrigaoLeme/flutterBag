import 'package:flutter/material.dart';

import '../../../../../../main/i18n/app_i18n.dart';
import '../../../../../components/components.dart';
import '../../../../../helpers/themes/themes.dart';
import '../member_registration_view_model.dart';

class MemberRegistrationPersonalDataSubStep extends StatefulWidget {
  final MemberRegistrationViewModel vm;
  final VoidCallback onSelectDate;
  final VoidCallback onOpenNationality;
  final VoidCallback onOpenPcd;
  final Future<void> Function(String cpf) onCpfComplete;

  const MemberRegistrationPersonalDataSubStep({
    super.key,
    required this.vm,
    required this.onSelectDate,
    required this.onOpenNationality,
    required this.onOpenPcd,
    required this.onCpfComplete,
  });

  @override
  State<MemberRegistrationPersonalDataSubStep> createState() =>
      _MemberRegistrationPersonalDataSubStepState();
}

class _MemberRegistrationPersonalDataSubStepState
    extends State<MemberRegistrationPersonalDataSubStep> {
  @override
  void initState() {
    super.initState();
    widget.vm.cpfController.addListener(_onCpfChanged);
  }

  @override
  void dispose() {
    widget.vm.cpfController.removeListener(_onCpfChanged);
    super.dispose();
  }

  void _onCpfChanged() {
    final clean = widget.vm.cpfController.text.replaceAll(RegExp(r'\D'), '');
    if (clean.length == 11) {
      widget.onCpfComplete(clean);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 8),
        SizedBox(
          height: 56,
          child: EbolsaTextField(
            controller: widget.vm.cpfController,
            label: AppI18n.current.authCpfLabel,
            keyboardType: TextInputType.number,
            inputFormatters: [widget.vm.cpfMask],
            onChanged: (value) {
              final clean = value.replaceAll(RegExp(r'\D'), '');
              if (clean.length == 11) {
                // TODO: chamar endpoint GET /persons/{cpf}
              }
            },
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 56,
          child: EbolsaTextField(
              controller: widget.vm.nameController,
              label: AppI18n.current.createAccountFullNameLabel),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 56,
                child: GestureDetector(
                  onTap: widget.onSelectDate,
                  child: AbsorbPointer(
                    child: EbolsaTextField(
                      controller: widget.vm.dobController,
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
                  initialValue: widget.vm.selectedGender,
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
                  items: widget.vm.genderOptions
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
                  onChanged: (v) => widget.vm.setSelectedGender(v),
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
                  initialValue: widget.vm.selectedResponsible,
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
                  items: widget.vm.responsibleOptions
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
                  onChanged: widget.vm.setSelectedResponsible,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 56,
                child: DropdownButtonFormField<MaritalStatus>(
                  initialValue: widget.vm.maritalStatus,
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.onSurface),
                  icon: const Icon(Icons.keyboard_arrow_down),
                  decoration: InputDecoration(
                    hintText: AppI18n.current.maritalStatusLabel,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 16),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: widget.vm.maritalOptions
                      .map((m) => DropdownMenuItem(
                          value: m,
                          child: Text(widget.vm.maritalDisplay(m),
                              style: AppTextStyles.bodyMedium)))
                      .toList(),
                  onChanged: (v) => widget.vm.setMarital(v),
                ),
              ),
            ),
          ],
        ),
        // se o estado civil for viuva deve aparecer esse campo abaixo para informar se recebe pensão
        if (widget.vm.showReceivesPension) ...[
          const SizedBox(height: 16),
          EbolsaRadioGroup<int>(
            question: AppI18n.current.receivesPensionQuestion,
            options: [
              RadioOption(label: AppI18n.current.answerNo, value: 0),
              RadioOption(label: AppI18n.current.answerYes, value: 1),
            ],
            groupValue: widget.vm.recebePensao,
            onChanged: (v) => widget.vm.setRecebePensao(v),
          ),
          // se ele responder que sim, deve mostrar o campo para inserir se é aposentado(a)?
          if (widget.vm.showIsRetired) ...[
            const SizedBox(height: 16),
            EbolsaRadioGroup<int>(
              question: AppI18n.current.isRetiredQuestion,
              options: [
                RadioOption(label: AppI18n.current.answerNo, value: 0),
                RadioOption(label: AppI18n.current.answerYes, value: 1),
              ],
              groupValue: widget.vm.aposentado,
              onChanged: (v) => widget.vm.setAposentado(v),
            ),
          ]
        ],
        const SizedBox(height: 16),
        EbolsaRadioGroup<int>(
          question: AppI18n.current.willApplyScholarshipQuestion,
          options: [
            RadioOption(label: AppI18n.current.answerNo, value: 0),
            RadioOption(label: AppI18n.current.answerYes, value: 1),
          ],
          groupValue: widget.vm.seraCandidato,
          onChanged: (v) => widget.vm.setSeraCandidato(v),
        ),
        //Se ele responder sim, mostrar o campo para selecionar a nacionalidade
        if (widget.vm.seraCandidato == 1) ...[
          const SizedBox(height: 12),
          SizedBox(
            height: 56,
            child: InkWell(
              onTap: widget.onOpenNationality,
              borderRadius: BorderRadius.circular(12),
              child: InputDecorator(
                decoration: InputDecoration(
                  hintText: AppI18n.current.nationalityLabel,
                  isDense: true,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: const Icon(Icons.keyboard_arrow_down),
                ),
                child: Text(
                  widget.vm.nacionalityController.text.isNotEmpty
                      ? widget.vm.nacionalityController.text
                      : AppI18n.current.nationalityLabel,
                  style: widget.vm.nacionalityController.text.isEmpty
                      ? AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.onSurface.withValues(alpha: 0.6))
                      : AppTextStyles.bodyMedium,
                ),
              ),
            ),
          ),
        ],
        // se ele for nacionalidade estrangeira deve mostrar o campo abaixo
        if ((widget.vm.nacionalityController.text.trim().isNotEmpty)) ...[
          const SizedBox(height: 16),
          EbolsaRadioGroup<int>(
            question: AppI18n.current.naturalizedQuestion,
            options: [
              RadioOption(label: AppI18n.current.answerNo, value: 0),
              RadioOption(label: AppI18n.current.answerYes, value: 1),
            ],
            groupValue: widget.vm.naturalizado,
            onChanged: (v) => widget.vm.setNaturalizado(v),
          ),
          //se ele responder que não é naturalizado, deve mostrar o campo abaixo de alerta EbolsaImportantBanner
          if (widget.vm.naturalizado == 0) ...[
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
            RadioOption(label: AppI18n.current.answerNo, value: 0),
            RadioOption(label: AppI18n.current.answerYes, value: 1),
          ],
          groupValue: widget.vm.possuiCIN,
          onChanged: (v) => widget.vm.setPossuiCIN(v),
        ),
        // se a resposta for sim, mostrar os campos abaixo para inserir o número do CIN e o órgão emissor
        if (widget.vm.possuiCIN == 1) ...[
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 56,
                  child: EbolsaTextField(
                      controller: widget.vm.rgController,
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
                      controller: widget.vm.orgaoController,
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
            RadioOption(label: AppI18n.current.answerNo, value: 0),
            RadioOption(label: AppI18n.current.answerYes, value: 1),
          ],
          groupValue: widget.vm.cadunicoValue,
          onChanged: (v) => widget.vm.setCadunicoValue(v),
        ),
        //se a responda for sim mostrar o campo para inserir o número do NIS (Cadúnico)
        if (widget.vm.cadunicoValue == 1) ...[
          SizedBox(
            height: 56,
            child: EbolsaTextField(
              controller: widget.vm.nisController,
              label: AppI18n.current.nisLabel,
            ),
          ),
        ],
        const SizedBox(height: 12),
        EbolsaRadioGroup<int>(
          question: 'Transtorno do Espectro Autista(TEA)?',
          options: [
            RadioOption(label: AppI18n.current.answerNo, value: 0),
            RadioOption(label: AppI18n.current.answerYes, value: 1),
          ],
          groupValue: widget.vm.espectro,
          onChanged: (v) => widget.vm.setEspectro(v),
        ),
        const SizedBox(height: 12),
        EbolsaRadioGroup<int>(
          question: 'Altas Habilidades ou Superdotação?',
          options: [
            RadioOption(label: AppI18n.current.answerNo, value: 0),
            RadioOption(label: AppI18n.current.answerYes, value: 1),
          ],
          groupValue: widget.vm.superdotacao,
          onChanged: (v) => widget.vm.setSuperdotacao(v),
        ),
        const SizedBox(height: 12),
        EbolsaRadioGroup<int>(
          question: AppI18n.current.hasChronicDiseaseQuestion,
          options: [
            RadioOption(label: AppI18n.current.answerNo, value: 0),
            RadioOption(label: AppI18n.current.answerYes, value: 1),
          ],
          groupValue: widget.vm.possuiDoenca,
          onChanged: (v) => widget.vm.setPossuiDoenca(v),
        ),
        // se a resposta for sim, mostrar o campo para inserir o tipo de doença
        if (widget.vm.possuiDoenca == 1) ...[
          SizedBox(
            height: 56,
            child: EbolsaTextField(
              controller: widget.vm.tipoDoencaController,
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
            onTap: widget.onOpenPcd,
            borderRadius: BorderRadius.circular(12),
            child: InputDecorator(
              decoration: InputDecoration(
                hintText: 'Selecione',
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: const Icon(Icons.keyboard_arrow_down),
              ),
              child: Text(
                widget.vm.selectedPcd ?? 'Selecione',
                style: widget.vm.selectedPcd == null
                    ? AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.onSurface.withValues(alpha: 0.6))
                    : AppTextStyles.bodyMedium,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        EbolsaRadioGroup<int>(
          question: AppI18n.current.irpfConditionLabel,
          options: [
            RadioOption(label: AppI18n.current.irpfDeclarante, value: 0),
            RadioOption(label: AppI18n.current.irpfIsento, value: 1),
          ],
          groupValue: widget.vm.irpfCondition,
          onChanged: (v) => widget.vm.setIrpfCondition(v),
        ),
        const SizedBox(height: 12),
        EbolsaRadioGroup<int>(
          question: AppI18n.current.declaredThisYearQuestion,
          options: [
            RadioOption(label: AppI18n.current.answerNo, value: 0),
            RadioOption(label: AppI18n.current.answerYes, value: 1),
          ],
          groupValue: widget.vm.declarouEsseAno,
          onChanged: (v) => widget.vm.setDeclarouEsseAno(v),
        ),
        const SizedBox(height: 12),
        EbolsaRadioGroup<int>(
          question: AppI18n.current.hasWorkCardQuestion,
          options: [
            RadioOption(label: AppI18n.current.answerNo, value: 0),
            RadioOption(label: AppI18n.current.answerYes, value: 1),
          ],
          groupValue: widget.vm.temCarteira,
          onChanged: (v) => widget.vm.setTemCarteira(v),
        ),
        const SizedBox(height: 12),
        EbolsaRadioGroup<int>(
          question: AppI18n.current.ruralWorkerQuestion,
          options: [
            RadioOption(label: AppI18n.current.answerNo, value: 0),
            RadioOption(label: AppI18n.current.answerYes, value: 1),
          ],
          groupValue: widget.vm.trabalhadorRural,
          onChanged: (v) => widget.vm.setTrabalhadorRural(v),
        ),
      ],
    );
  }
}
