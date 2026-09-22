import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../../../../domain/entities/enrollment_enums.dart';
import '../../../../../../main/i18n/app_i18n.dart';
import '../../../../../components/components.dart';
import '../../../../../helpers/themes/themes.dart';
import '../member_registration_view_model.dart';

class MemberRegistrationPersonalDataSubStep extends StatefulWidget {
  final MemberRegistrationViewModel vm;
  final VoidCallback onOpenNationality;
  final VoidCallback onOpenPcd;
  final Future<void> Function(String cpf) onCpfComplete;

  const MemberRegistrationPersonalDataSubStep({
    super.key,
    required this.vm,
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
    if (widget.vm.isEditing) return;

    final clean = widget.vm.cpfController.text.replaceAll(RegExp(r'\D'), '');
    if (clean.length == 11) {
      if (!CPFValidator.isValid(clean)) {
        widget.vm.setCpfError(AppI18n.current.loginValidationInvalidCpf);
        return;
      }

      if (widget.vm.isCpfAlreadyAdded(clean)) {
        widget.vm.setCpfError(AppI18n.current.cpfAlreadyAddedError);
        // Mostra dialog informativo
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          EbolsaDialog.show(
            context: context,
            title: AppI18n.current.cpfAlreadyAddedDialogTitle,
            description: AppI18n.current.cpfAlreadyAddedDialogDescription,
            actions: [
              EbolsaDialogAction(
                label: AppI18n.current.dialogOk,
                isPrimary: true,
                onPressed: () {
                  widget.vm.cpfController.clear();
                  widget.vm.setCpfError(null);
                },
              ),
            ],
          );
        });
        return;
      }

      widget.vm.setCpfError(null);
      widget.onCpfComplete(clean);
    } else {
      widget.vm.setCpfError(null);
    }
  }

  final _dobMask = MaskTextInputFormatter(
    mask: '##/##/####',
    filter: {'#': RegExp(r'\d')},
  );

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
            errorText: widget.vm.cpfError,
            enabled: !widget.vm.isEditing,
          ),
        ),
        if (widget.vm.isLoadingPerson)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ],
          ),
        const SizedBox(height: 12),
        EbolsaIgnorePointer(
          ignoring: (!widget.vm.isCpfValidated || widget.vm.isLoadingPerson) &&
              !widget.vm.isEditing,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 56,
                child: EbolsaTextField(
                  controller: widget.vm.nameController,
                  label: AppI18n.current.createAccountFullNameLabel,
                  enabled:
                      widget.vm.isCpfValidated && !widget.vm.isLoadingPerson,
                ),
              ),

              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: EbolsaTextField(
                        controller: widget.vm.dobController,
                        label: AppI18n.current.dobLabel,
                        hint: 'dd/mm/aaaa',
                        keyboardType: TextInputType.number,
                        inputFormatters: [_dobMask],
                        enabled: widget.vm.isCpfValidated &&
                            !widget.vm.isLoadingPerson,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final selected =
                            await SearchableOptionsBottomSheet.show<Gender>(
                          showSearchInput: false,
                          enabled: !widget.vm.isCpfValidated ||
                              widget.vm.isLoadingPerson,
                          context: context,
                          title: AppI18n.current.genderLabel,
                          options: widget.vm.genderOptions,
                          searchHint: AppI18n.current.noticesTermsSearchHint,
                          helperText: '',
                          emptyStateText:
                              AppI18n.current.noticesTermsBottomSheetNoResults,
                          closeTooltip: AppI18n.current.noticesTermsCloseAction,
                          selectedValue: widget.vm.selectedGenderEnum,
                          labelBuilder: (g) => g.label,
                          searchTextBuilder: (g) => g.label,
                        );
                        if (selected != null) {
                          widget.vm.setSelectedGenderEnum(selected);
                        }
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: AppI18n.current.genderLabel,
                          suffixIcon:
                              const Icon(Icons.keyboard_arrow_down_rounded),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Text(
                          widget.vm.selectedGender ??
                              AppI18n.current.genderLabel,
                          style: widget.vm.selectedGender == null
                              ? AppTextStyles.ebolsaBodyLargeOutline
                              : AppTextStyles.ebolsaBodyLarge,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  if (!widget.vm.isFirstMember) ...[
                    Expanded(
                      child: EbolsaIgnorePointer(
                        ignoring:
                            widget.vm.kinshipType == KinshipType.responsible,
                        child: GestureDetector(
                          onTap: () async {
                            final selected = await SearchableOptionsBottomSheet
                                .show<KinshipType>(
                              context: context,
                              title: AppI18n.current.kinshipLabel,
                              options: widget.vm.kinshipOptions,
                              searchHint:
                                  AppI18n.current.noticesTermsSearchHint,
                              helperText: '',
                              emptyStateText: AppI18n
                                  .current.noticesTermsBottomSheetNoResults,
                              closeTooltip:
                                  AppI18n.current.noticesTermsCloseAction,
                              selectedValue: widget.vm.kinshipType,
                              labelBuilder: (k) => k.label,
                              searchTextBuilder: (k) => k.label,
                            );
                            if (selected != null) {
                              widget.vm.setKinshipType(selected);
                            }
                          },
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: AppI18n.current.kinshipLabel,
                              suffixIcon:
                                  const Icon(Icons.keyboard_arrow_down_rounded),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16)),
                            ),
                            child: Text(
                              widget.vm.kinshipType?.label ??
                                  AppI18n.current.kinshipLabel,
                              style: widget.vm.kinshipType == null
                                  ? AppTextStyles.ebolsaBodyLargeOutline
                                  : AppTextStyles.ebolsaBodyLarge,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final selected = await SearchableOptionsBottomSheet
                            .show<MaritalStatus>(
                          showSearchInput: false,
                          context: context,
                          title: AppI18n.current.maritalStatusLabel,
                          options: widget.vm.maritalOptions,
                          searchHint: AppI18n.current.noticesTermsSearchHint,
                          helperText: '',
                          emptyStateText:
                              AppI18n.current.noticesTermsBottomSheetNoResults,
                          closeTooltip: AppI18n.current.noticesTermsCloseAction,
                          selectedValue: widget.vm.maritalStatus,
                          labelBuilder: (m) => m.label,
                          searchTextBuilder: (m) => m.label,
                        );
                        if (selected != null) widget.vm.setMarital(selected);
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: AppI18n.current.maritalStatusLabel,
                          suffixIcon:
                              const Icon(Icons.keyboard_arrow_down_rounded),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Text(
                          widget.vm.maritalStatus?.label ??
                              AppI18n.current.maritalStatusLabel,
                          style: widget.vm.maritalStatus == null
                              ? AppTextStyles.ebolsaBodyLargeOutline
                              : AppTextStyles.ebolsaBodyLarge,
                        ),
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
              if (widget.vm.showCandidateField(
                isFirstMember: widget.vm.addedFamilyMembers.isEmpty,
                isHigherEducation: widget.vm.isHigherEducation,
              )) ...[
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
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 16),
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
                                  color: AppColors.onSurface
                                      .withValues(alpha: 0.6))
                              : AppTextStyles.bodyMedium,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
              // se ele for nacionalidade estrangeira deve mostrar o campo abaixo
              if (widget.vm.showNaturalizedField) ...[
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
              if (widget.vm.possuiCIN == 0) ...[
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
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 16),
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
              if (widget.vm.legalAge) ...[
                const SizedBox(height: 12),
                EbolsaRadioGroup<int>(
                  question: AppI18n.current.irpfConditionLabel,
                  options: [
                    RadioOption(
                        label: AppI18n.current.irpfDeclarante, value: 1),
                    RadioOption(label: AppI18n.current.irpfIsento, value: 2),
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
              ],
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
          ),
        ),
      ],
    );
  }
}
