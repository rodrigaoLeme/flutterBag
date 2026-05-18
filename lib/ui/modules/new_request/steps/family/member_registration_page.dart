import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../main/i18n/app_i18n.dart';
import '../../../../components/components.dart';
import '../../../../components/ebolsa_typeahead_field.dart';
import '../../../../helpers/themes/themes.dart';
import '../../widgets/scholarship_step_indicator.dart';
import 'member_registration_view_model.dart';

class MemberRegistrationPage extends StatefulWidget {
  const MemberRegistrationPage({super.key});

  @override
  State<MemberRegistrationPage> createState() => _MemberRegistrationPageState();
}

class _MemberRegistrationPageState extends State<MemberRegistrationPage> {
  late final MemberRegistrationViewModel _vm;
  int _currentSubStep = 1;
  static const int _totalSubSteps = 3;
  late final ScrollController _scrollController;

  @override
  void dispose() {
    _scrollController.dispose();
    _vm.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _vm = MemberRegistrationViewModel();
    _vm.addListener(() => setState(() {}));
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime initial = DateTime.now().subtract(const Duration(days: 365 * 18));
    if (_vm.dobController.text.trim().isNotEmpty) {
      try {
        initial = DateFormat('dd/MM/yyyy').parse(_vm.dobController.text);
      } catch (_) {}
      if (initial.isAfter(DateTime.now())) {
        initial = DateTime.now();
      }
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendar,
    );

    if (picked != null) {
      setState(() {
        _vm.dobController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppI18n.current.memberRegistrationAppBarTitle),
        centerTitle: true,
        leading: BackButton(color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: ScholarshipStepIndicator(currentStep: 2),
            ),
            Expanded(
              child: Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                thickness: 2.0,
                radius: const Radius.circular(8),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        AppI18n.current.memberRegistrationTitle,
                        style: AppTextStyles.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppI18n.current.memberRegistrationDescription,
                        style: AppTextStyles.bodyMedium,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: _currentSubStep > 1
                                  ? () => setState(() => _currentSubStep--)
                                  : null,
                              behavior: HitTestBehavior.opaque,
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: _currentSubStep > 1
                                      ? AppColors.surface
                                      : AppColors.surface,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.arrow_back,
                                    color: _currentSubStep > 1
                                        ? AppColors.surfaceCl
                                        : AppColors.outline),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Center(
                                child: Text(
                                  AppI18n.current.personalDataTitle,
                                  style: AppTextStyles.titleLarge,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            GestureDetector(
                              onTap: _currentSubStep < _totalSubSteps
                                  ? () => setState(() => _currentSubStep++)
                                  : null,
                              behavior: HitTestBehavior.opaque,
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: _currentSubStep < _totalSubSteps
                                      ? AppColors.primary
                                      : AppColors.surface,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.arrow_forward,
                                    color: _currentSubStep < _totalSubSteps
                                        ? Colors.white
                                        : AppColors.outline),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_currentSubStep == 1) ...[
                        SizedBox(height: 8),
                        SizedBox(
                          height: 56,
                          child: EbolsaTextField(
                              controller: _vm.cpfController,
                              label: AppI18n.current.authCpfLabel),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                            height: 56,
                            child: EbolsaTextField(
                                controller: _vm.nameController,
                                label: AppI18n
                                    .current.createAccountFullNameLabel)),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 56,
                                child: GestureDetector(
                                  onTap: () => _selectDate(context),
                                  child: AbsorbPointer(
                                    child: EbolsaTextField(
                                      controller: _vm.dobController,
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
                                  initialValue: _vm.selectedGender,
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
                                  items: _vm.genderOptions
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
                                  onChanged: (v) =>
                                      setState(() => _vm.selectedGender = v),
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
                                  initialValue: _vm.selectedResponsible,
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
                                  items: _vm.responsibleOptions
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
                                  onChanged: (v) => setState(
                                      () => _vm.selectedResponsible = v),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: SizedBox(
                                height: 56,
                                child: DropdownButtonFormField<MaritalStatus>(
                                  initialValue: _vm.maritalStatus,
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
                                  items: _vm.maritalOptions
                                      .map((m) => DropdownMenuItem(
                                          value: m,
                                          child: Text(_vm.maritalDisplay(m),
                                              style: AppTextStyles.bodyMedium)))
                                      .toList(),
                                  onChanged: (v) => _vm.setMarital(v),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // se o estado civil for viuva deve aparecer esse campo abaixo para informar se recebe pensão
                        if (_vm.showReceivesPension) ...[
                          const SizedBox(height: 16),
                          Text(
                            AppI18n.current.receivesPensionQuestion,
                            style: AppTextStyles.bodyMedium,
                          ),
                          const SizedBox(height: 8),
                          RadioGroup<int>(
                            groupValue: _vm.recebePensao,
                            onChanged: (v) => _vm.setRecebePensao(v),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () => _vm.setRecebePensao(0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Radio<int>(
                                        value: 0,
                                      ),
                                      Text(AppI18n.current.answerNo),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                InkWell(
                                  onTap: () => _vm.setRecebePensao(1),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Radio<int>(
                                        value: 1,
                                      ),
                                      Text(AppI18n.current.answerYes),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // se ele responder que sim, deve mostrar o campo para inserir se é aposentado(a)?
                          if (_vm.showIsRetired) ...[
                            const SizedBox(height: 16),
                            Text(AppI18n.current.isRetiredQuestion,
                                style: AppTextStyles.bodyMedium),
                            const SizedBox(height: 8),
                            RadioGroup<int>(
                              groupValue: _vm.aposentado,
                              onChanged: (v) => _vm.setAposentado(v),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () => _vm.setAposentado(0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Radio<int>(
                                          value: 0,
                                        ),
                                        Text(AppI18n.current.answerNo),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  InkWell(
                                    onTap: () => _vm.setAposentado(1),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Radio<int>(
                                          value: 1,
                                        ),
                                        Text(AppI18n.current.answerYes),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ]
                        ],
                        const SizedBox(height: 16),
                        Text(AppI18n.current.willApplyScholarshipQuestion,
                            style: AppTextStyles.bodyMedium),
                        const SizedBox(height: 8),
                        RadioGroup<int>(
                          groupValue: _vm.seraCandidato,
                          onChanged: (v) => _vm.setSeraCandidato(v),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () => _vm.setSeraCandidato(0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Radio<int>(
                                      value: 0,
                                    ),
                                    Text(AppI18n.current.answerNo),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              InkWell(
                                onTap: () => _vm.setSeraCandidato(1),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Radio<int>(
                                      value: 1,
                                    ),
                                    Text(AppI18n.current.answerYes),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        //Se ele responder sim, mostrar o campo para inserir a nacionalidade
                        if (_vm.seraCandidato == 1) ...[
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 56,
                            child: EbolsaTypeAheadField(
                              controller: _vm.nacionalityController,
                              label: AppI18n.current.nationalityLabel,
                              suggestions: _vm.nationalityOptions,
                              onChanged: (s) => setState(() {}),
                              onSuggestionSelected: (s) => setState(() {}),
                            ),
                          ),
                        ],
                        // se ele for nacionalidade estrangeira deve mostrar o campo abaixo
                        if ((_vm.nacionalityController.text
                            .trim()
                            .isNotEmpty)) ...[
                          const SizedBox(height: 16),
                          Text(AppI18n.current.naturalizedQuestion,
                              style: AppTextStyles.bodyMedium),
                          const SizedBox(height: 8),
                          RadioGroup<int>(
                            groupValue: _vm.naturalizado,
                            onChanged: (v) => _vm.setSeraCandidato(v),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () => _vm.setNaturalizado(0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Radio<int>(
                                        value: 0,
                                      ),
                                      Text(AppI18n.current.answerNo),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                InkWell(
                                  onTap: () => _vm.setNaturalizado(1),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Radio<int>(
                                        value: 1,
                                      ),
                                      Text(AppI18n.current.answerYes),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          //se ele responder que não é naturalizado, deve mostrar o campo abaixo de alerta EbolsaImportantBanner
                          if (_vm.naturalizado == 0) ...[
                            EbolsaImportantBanner(
                              title: AppI18n.current.concessionBannerTitle,
                              message: AppI18n.current.concessionBannerMessage,
                            ),
                          ]
                        ],
                        const SizedBox(height: 12),
                        Text(AppI18n.current.hasCINQuestion,
                            style: AppTextStyles.bodyMedium),
                        const SizedBox(height: 8),
                        RadioGroup<int>(
                          groupValue: _vm.possuiCIN,
                          onChanged: (v) => setState(() => _vm.possuiCIN = v),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () => setState(() => _vm.possuiCIN = 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Radio<int>(
                                      value: 0,
                                    ),
                                    Text(AppI18n.current.answerNo),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              InkWell(
                                onTap: () => setState(() => _vm.possuiCIN = 1),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Radio<int>(
                                      value: 1,
                                    ),
                                    Text(AppI18n.current.answerYes),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        // se a resposta for sim, mostrar os campos abaixo para inserir o número do CIN e o órgão emissor
                        if (_vm.possuiCIN == 1) ...[
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 56,
                                  child: EbolsaTextField(
                                      controller: _vm.rgController,
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
                                      controller: _vm.orgaoController,
                                      label: AppI18n.current.issuingOrgLabel),
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 12),
                        Text(AppI18n.current.hasCadunicoQuestion,
                            style: AppTextStyles.bodyMedium),
                        const SizedBox(height: 8),
                        RadioGroup<int>(
                          groupValue: _vm.cadunicoValue,
                          onChanged: (v) =>
                              setState(() => _vm.cadunicoValue = v),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () =>
                                    setState(() => _vm.cadunicoValue = 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Radio<int>(
                                      value: 0,
                                    ),
                                    Text(AppI18n.current.answerNo),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              InkWell(
                                onTap: () =>
                                    setState(() => _vm.cadunicoValue = 1),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Radio<int>(
                                      value: 1,
                                    ),
                                    Text(AppI18n.current.answerYes),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        //se a responda for sim mostrar o campo para inserir o número do NIS (Cadúnico)
                        if (_vm.cadunicoValue == 1) ...[
                          SizedBox(
                            height: 56,
                            child: EbolsaTextField(
                              controller: _vm.nisController,
                              label: AppI18n.current.nisLabel,
                            ),
                          ),
                        ],
                        const SizedBox(height: 12),
                        Text(AppI18n.current.hasChronicDiseaseQuestion,
                            style: AppTextStyles.bodyMedium),
                        const SizedBox(height: 8),
                        RadioGroup<int>(
                          groupValue: _vm.possuiDoenca,
                          onChanged: (v) =>
                              setState(() => _vm.possuiDoenca = v),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () =>
                                    setState(() => _vm.possuiDoenca = 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Radio<int>(
                                      value: 0,
                                    ),
                                    Text(AppI18n.current.answerNo),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              InkWell(
                                onTap: () =>
                                    setState(() => _vm.possuiDoenca = 1),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Radio<int>(
                                      value: 1,
                                    ),
                                    Text(AppI18n.current.answerYes),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        // se a resposta for sim, mostrar o campo para inserir o tipo de doença
                        if (_vm.possuiDoenca == 1) ...[
                          SizedBox(
                            height: 56,
                            child: EbolsaTextField(
                              controller: _vm.tipoDoencaController,
                              label: AppI18n.current.diseaseTypeLabel,
                            ),
                          ),
                        ],

                        // O dropdown de PcD deve aparecer sempre
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 56,
                          child: DropdownButtonFormField<String>(
                            initialValue: _vm.selectedPcd,
                            style: AppTextStyles.bodyMedium
                                .copyWith(color: AppColors.onSurface),
                            icon: const Icon(Icons.keyboard_arrow_down),
                            decoration: InputDecoration(
                              hintText: AppI18n.current.pcdLabel,
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 16),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            items: _vm.pcdOptions
                                .map((m) => DropdownMenuItem(
                                    value: m,
                                    child: Text(m,
                                        style: AppTextStyles.bodyMedium)))
                                .toList(),
                            onChanged: (v) =>
                                setState(() => _vm.selectedPcd = v),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(AppI18n.current.irpfConditionLabel,
                            style: AppTextStyles.bodyMedium),
                        const SizedBox(height: 8),
                        RadioGroup<int>(
                          groupValue: _vm.irpfCondition,
                          onChanged: (v) =>
                              setState(() => _vm.irpfCondition = v),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () =>
                                    setState(() => _vm.irpfCondition = 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Radio<int>(
                                      value: 0,
                                    ),
                                    Text(AppI18n.current.irpfDeclarante),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              InkWell(
                                onTap: () =>
                                    setState(() => _vm.irpfCondition = 1),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Radio<int>(
                                      value: 1,
                                    ),
                                    Text(AppI18n.current.irpfIsento),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(AppI18n.current.declaredThisYearQuestion,
                            style: AppTextStyles.bodyMedium),
                        const SizedBox(height: 8),
                        RadioGroup<int>(
                          groupValue: _vm.declarouEsseAno,
                          onChanged: (v) =>
                              setState(() => _vm.declarouEsseAno = v),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () =>
                                    setState(() => _vm.declarouEsseAno = 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Radio<int>(
                                      value: 0,
                                    ),
                                    Text(AppI18n.current.answerNo),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              InkWell(
                                onTap: () =>
                                    setState(() => _vm.declarouEsseAno = 1),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Radio<int>(
                                      value: 1,
                                    ),
                                    Text(AppI18n.current.answerYes),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(AppI18n.current.hasWorkCardQuestion,
                            style: AppTextStyles.bodyMedium),
                        const SizedBox(height: 8),
                        RadioGroup<int>(
                          groupValue: _vm.temCarteira,
                          onChanged: (v) => setState(() => _vm.temCarteira = v),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () =>
                                    setState(() => _vm.temCarteira = 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Radio<int>(
                                      value: 0,
                                    ),
                                    Text(AppI18n.current.answerNo),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              InkWell(
                                onTap: () =>
                                    setState(() => _vm.temCarteira = 1),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Radio<int>(
                                      value: 1,
                                    ),
                                    Text(AppI18n.current.answerYes),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(AppI18n.current.ruralWorkerQuestion,
                            style: AppTextStyles.bodyMedium),
                        const SizedBox(height: 8),
                        RadioGroup<int>(
                          groupValue: _vm.trabalhadorRural,
                          onChanged: (v) =>
                              setState(() => _vm.trabalhadorRural = v),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () =>
                                    setState(() => _vm.trabalhadorRural = 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Radio<int>(
                                      value: 0,
                                    ),
                                    Text(AppI18n.current.answerNo),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              InkWell(
                                onTap: () =>
                                    setState(() => _vm.trabalhadorRural = 1),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Radio<int>(
                                      value: 1,
                                    ),
                                    Text(AppI18n.current.answerYes),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ] else if (_currentSubStep == 2) ...[
                        Center(
                          child: Text(
                            AppI18n.current.dataComplementTitle,
                            style: AppTextStyles.titleLarge,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(AppI18n.current.complementFieldsPlaceholder,
                            style: AppTextStyles.bodyMedium),
                        const SizedBox(height: 200),
                      ] else ...[
                        Center(
                            child: Text(AppI18n.current.documentsTitle,
                                style: AppTextStyles.titleLarge)),
                        const SizedBox(height: 12),
                        Text(AppI18n.current.documentsPlaceholder,
                            style: AppTextStyles.bodyMedium),
                        const SizedBox(height: 200),
                      ],
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: EbolsaButton(
                onPressed: () {
                  if (_currentSubStep < _totalSubSteps) {
                    setState(() => _currentSubStep++);
                    return;
                  }
                  Navigator.of(context).pop();
                },
                label: _currentSubStep < _totalSubSteps
                    ? AppI18n.current.createAccountNextAction
                    : AppI18n.current.concludeAction,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
