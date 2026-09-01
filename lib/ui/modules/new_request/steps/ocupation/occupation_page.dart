import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../../../domain/entities/occupation_type_entity.dart';
import '../../../../../main/i18n/app_i18n.dart';
import '../../../../components/components.dart';
import '../../../../helpers/money_text_input_formatter.dart';
import '../../../../helpers/themes/themes.dart';
import 'occupation_type.dart';
import 'ocupation_details_view_model.dart';

class OccupationPage extends StatefulWidget {
  const OccupationPage({
    super.key,
    this.initialPension = 0,
    this.initialPrevidencia = 0,
    this.initialInss = 0,
    this.initialOccupation,
    this.initialOccupationDetails,
    this.initialMonthlyIncome,
    this.occupationTypes = const [],
    this.memberBirthDate,
  });

  final int initialPension;
  final int initialPrevidencia;
  final int initialInss;
  final String? initialOccupation;
  final Map<String, String>? initialOccupationDetails;
  final String? initialMonthlyIncome;
  final List<OccupationTypeEntity> occupationTypes;
  final String? memberBirthDate;

  @override
  State<OccupationPage> createState() => _OccupationPageState();
}

class _OccupationPageState extends State<OccupationPage> {
  late int _recebePensaoAlimenticia;
  late int _recebePrevidenciaPrivada;
  late int _recebeOutroBeneficioINSS;
  bool _studentAcknowledged = false;

  // Calcula idade do membro a partir da data de nascimento
  int get _memberAge {
    if (widget.memberBirthDate == null || widget.memberBirthDate!.isEmpty) {
      return 99;
    }
    try {
      final dob = DateFormat('dd/MM/yyyy').parse(widget.memberBirthDate!);
      final now = DateTime.now();
      int age = now.year - dob.year;
      if (now.month < dob.month ||
          (now.month == dob.month && now.day < dob.day)) {
        age--;
      }
      return age;
    } catch (_) {
      return 99;
    }
  }

  List<String> get _occupationOptions {
    if (widget.occupationTypes.isEmpty) {
      return const [
        'Nenhum',
        'Estudante',
        'Assalariado(a)',
        'Proprietário(a) ou Sócio(a) de Empresa',
        'Autônomo(a) ou Profissional Liberal',
        'Trabalhador(a) Informal',
        'Estagiário',
        'Estágio não Remunerado',
        'Aposentado e/ou Pensionista',
        'Beneficiário(a) de Prestação Continuada (BPC)',
        'Desempregado(a)',
        'Do Lar',
      ];
    }
    // Filtra por idade usando ocupationRules quando confirmado
    // Por enquanto retorna todos os tipos ordenados
    // TODO: aplicar filtro de ocupationRules quando regras confirmadas com backend
    return widget.occupationTypes
        .map((t) => t.name ?? '')
        .where((name) => name.isNotEmpty)
        .toList();
  }

  OccupationTypeEntity? _selectedOccupationType(String? name) {
    if (name == null || widget.occupationTypes.isEmpty) return null;
    try {
      return widget.occupationTypes.firstWhere((t) => t.name == name);
    } catch (_) {
      return null;
    }
  }

  String? _selectedOccupation;
  OccupationDetailsViewModel? _detailsViewModel;
  String? _genericLabel;
  TextEditingController? _incomeController;
  TextEditingController? _movimentacaoValueController;

  static const _movimentacaoQuestionKey = 'Houve movimentacao?';
  static const _movimentacaoValueKey = 'Valor movimentacao';

  @override
  void initState() {
    super.initState();

    _recebePensaoAlimenticia = widget.initialPension;
    _recebePrevidenciaPrivada = widget.initialPrevidencia;
    _recebeOutroBeneficioINSS = widget.initialInss;
    // If an initial occupation was provided, pre-select and populate fields
    if (widget.initialOccupation != null) {
      _selectedOccupation = widget.initialOccupation;
      switch (widget.initialOccupation) {
        case 'Estudante':
          _setDetailsViewModel(OccupationType.estudante);
          break;
        case 'Proprietário(a) ou Sócio(a) de Empresa':
          _setDetailsViewModel(OccupationType.propietario);
          break;
        case 'Assalariado(a)':
          _setDetailsViewModel(OccupationType.assalariado);
          break;
        case 'Autônomo(a) ou Profissional Liberal':
          _setDetailsViewModel(OccupationType.autonomo);
          break;
        case 'Trabalhador(a) Informal':
          _setDetailsViewModel(OccupationType.informal);
          break;
        case 'Estagiário':
          _setDetailsViewModel(OccupationType.estagiario);
          break;
        case 'Estágio não Remunerado':
          _setDetailsViewModel(OccupationType.estagioNaoRemunerado);
          break;
        case 'Aposentado e/ou Pensionista':
          _setDetailsViewModel(OccupationType.aposentado);
          break;
        case 'Beneficiário(a) de Prestação Continuada (BPC)':
          break;
        case 'Desempregado(a)':
          _setDetailsViewModel(OccupationType.desempregado);
          break;
        case 'Do Lar':
          _setDetailsViewModel(OccupationType.doLar);
          break;
        case 'Nenhum':
          _clearDetails();
          break;
        default:
          _setGeneric(widget.initialOccupation!);
      }

      // populate controllers if details provided
      if (widget.initialOccupationDetails != null &&
          _detailsViewModel != null) {
        for (final entry in widget.initialOccupationDetails!.entries) {
          final controller = _detailsViewModel!.controllers[entry.key];
          if (controller != null) controller.text = entry.value;
        }
        final movimentacaoValue =
            widget.initialOccupationDetails![_movimentacaoValueKey];
        if (movimentacaoValue != null && movimentacaoValue.isNotEmpty) {
          _ensureMovimentacaoValueController().text = movimentacaoValue;
        }
      }

      if (widget.initialMonthlyIncome != null) {
        _incomeController ??= TextEditingController();
        _incomeController!.text = widget.initialMonthlyIncome!;
      }
      // ensure listeners are attached for pre-populated controllers
      if (_incomeController != null) {
        _incomeController!.addListener(() => setState(() {}));
      }
      if (_detailsViewModel != null) {
        for (final c in _detailsViewModel!.controllers.values) {
          c.addListener(() => setState(() {}));
        }
      }
      // if opened for edit and occupation is estudante, consider it already acknowledged
      _studentAcknowledged = widget.initialOccupation == 'Estudante';
    }
  }

  void _saveAndReturn() {
    final occupationType = _selectedOccupationType(_selectedOccupation);

    final Map<String, dynamic> result = {
      'pension': _recebePensaoAlimenticia,
      'previdencia': _recebePrevidenciaPrivada,
      'inss': _recebeOutroBeneficioINSS,
      'occupation': _selectedOccupation,
      'ocupationTypeId': occupationType?.id,
    };

    if (_detailsViewModel != null) {
      final details =
          _detailsViewModel!.controllers.map((k, v) => MapEntry(k, v.text));
      if (_movimentacaoValueController != null &&
          _movimentacaoValueController!.text.trim().isNotEmpty) {
        details[_movimentacaoValueKey] =
            _movimentacaoValueController!.text.trim();
      }
      result['occupationDetails'] = details;

      if (_detailsViewModel!.type == OccupationType.propietario) {
        result['monthlyIncome'] = _showMovimentacaoValueField
            ? _movimentacaoValueController?.text
            : '0';
      } else {
        result['monthlyIncome'] = _incomeController?.text;
      }
    } else if (_genericLabel != null) {
      result['occupationDetails'] = {'label': _genericLabel};
      result['monthlyIncome'] = _incomeController?.text;
    }

    print('>>> monthlyIncome salvo: ${result['monthlyIncome']}');
    print('>>> movimentacaoValue: ${_movimentacaoValueController?.text}');
    print('>>> showMovimentacao: $_showMovimentacaoValueField');

    Navigator.of(context).pop(result);
  }

  @override
  void dispose() {
    _detailsViewModel?.dispose();
    _incomeController?.dispose();
    _movimentacaoValueController?.dispose();
    super.dispose();
  }

  Future<void> _openOptionsSelector({
    required String title,
    required List<String> options,
    String? selectedValue,
    required ValueChanged<String> onSelected,
  }) async {
    final appStrings = AppI18n.current;
    final selected = await SearchableOptionsBottomSheet.show<String>(
      context: context,
      title: title,
      options: options,
      searchHint: appStrings.noticesTermsSearchHint,
      helperText: appStrings.noticesTermsBottomSheetSearchHelp,
      emptyStateText: appStrings.noticesTermsBottomSheetNoResults,
      closeTooltip: appStrings.noticesTermsCloseAction,
      selectedValue: selectedValue,
      showSearchInput: false,
    );
    if (selected != null) {
      onSelected(selected);
    }
  }

  Future<void> _openFieldSelector({
    required String fieldLabel,
    required List<String> options,
    required TextEditingController controller,
  }) async {
    await _openOptionsSelector(
      title: fieldLabel,
      options: options,
      selectedValue: controller.text.isNotEmpty ? controller.text : null,
      onSelected: (selected) => setState(() => controller.text = selected),
    );
  }

  Widget _buildSearchableSelectorField({
    required String label,
    required String? selectedValue,
    required VoidCallback onTap,
    String placeholder = 'Selecione',
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.bodyMedium),
          const SizedBox(height: 8),
          SizedBox(
            height: 56,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(12),
              child: InputDecorator(
                decoration: InputDecoration(
                  hintText: placeholder,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: const Icon(Icons.keyboard_arrow_down),
                ),
                child: Text(
                  selectedValue ?? placeholder,
                  style: selectedValue == null
                      ? AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.onSurface.withValues(alpha: 0.6),
                        )
                      : AppTextStyles.bodyMedium,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openOccupationSelector() async {
    final appStrings = AppI18n.current;
    final selected = await SearchableOptionsBottomSheet.show<String>(
      context: context,
      title: appStrings.occupationTitle,
      options: _occupationOptions,
      searchHint: appStrings.noticesTermsSearchHint,
      helperText: appStrings.noticesTermsBottomSheetSearchHelp,
      emptyStateText: appStrings.noticesTermsBottomSheetNoResults,
      closeTooltip: appStrings.noticesTermsCloseAction,
      selectedValue: _selectedOccupation,
      showSearchInput: false,
    );

    if (selected == null) return;

    setState(() {
      _selectedOccupation = selected;
    });

    switch (selected) {
      case 'Estudante':
        _setDetailsViewModel(OccupationType.estudante);
        break;
      case 'Proprietário(a) ou Sócio(a) de Empresa':
        _setDetailsViewModel(OccupationType.propietario);
        break;
      case 'Assalariado(a)':
        _setDetailsViewModel(OccupationType.assalariado);
        break;
      case 'Autônomo(a) ou Profissional Liberal':
        _setDetailsViewModel(OccupationType.autonomo);
        break;
      case 'Trabalhador(a) Informal':
        _setDetailsViewModel(OccupationType.informal);
        break;
      case 'Estagiário':
        _setDetailsViewModel(OccupationType.estagiario);
        break;
      case 'Estágio não Remunerado':
        _setDetailsViewModel(OccupationType.estagioNaoRemunerado);
        break;
      case 'Aposentado e/ou Pensionista':
        _setDetailsViewModel(OccupationType.aposentado);
        break;
      case 'Beneficiário(a) de Prestação Continuada (BPC)':
        break;
      case 'Desempregado(a)':
        _setDetailsViewModel(OccupationType.desempregado);
        break;
      case 'Do Lar':
        _setDetailsViewModel(OccupationType.doLar);
        break;
      case 'Nenhum':
        _clearDetails();
        break;
      default:
        _setGeneric(selected);
    }

    if (selected == 'Estudante') {
      await _showStudentDialog();
    }
  }

  void _setDetailsViewModel(OccupationType type) {
    _detailsViewModel?.dispose();
    _genericLabel = null;
    _incomeController?.dispose();
    _incomeController = null;
    _movimentacaoValueController?.dispose();
    _movimentacaoValueController = null;
    _incomeController = TextEditingController();

    final occupationType = _selectedOccupationType(_selectedOccupation);
    _detailsViewModel = OccupationDetailsViewModel(
      type: type,
      externalDescription: occupationType?.description,
    );

    // listen to controllers to update button state when user types
    _incomeController!.addListener(() => setState(() {}));
    for (final c in _detailsViewModel!.controllers.values) {
      c.addListener(() => setState(() {}));
    }
    // require acknowledgement for estudante; reset to false
    _studentAcknowledged = false;
  }

  void _setGeneric(String label) {
    _detailsViewModel?.dispose();
    _detailsViewModel = null;
    _genericLabel = label;
    _incomeController?.dispose();
    _incomeController = TextEditingController();
    _incomeController!.addListener(() => setState(() {}));
  }

  void _clearDetails() {
    _detailsViewModel?.dispose();
    _detailsViewModel = null;
    _genericLabel = null;
    _incomeController?.dispose();
    _incomeController = null;
    _movimentacaoValueController?.dispose();
    _movimentacaoValueController = null;
    setState(() {});
  }

  TextEditingController _ensureMovimentacaoValueController() {
    if (_movimentacaoValueController != null) {
      return _movimentacaoValueController!;
    }
    _movimentacaoValueController = TextEditingController();
    _movimentacaoValueController!.addListener(() => setState(() {}));
    return _movimentacaoValueController!;
  }

  bool get _showMovimentacaoValueField {
    if (_detailsViewModel == null || !_detailsViewModel!.showMovimentacao) {
      return false;
    }
    return _detailsViewModel!.controllers[_movimentacaoQuestionKey]?.text ==
        'Sim';
  }

  bool get _showUnemploymentIncomeField {
    if (_detailsViewModel?.type != OccupationType.desempregado) return false;
    return _detailsViewModel!.controllers['Recebe seguro desemprego?']?.text ==
        'Sim';
  }

  TextEditingController _ensureIncomeController() {
    if (_incomeController != null) return _incomeController!;
    _incomeController = TextEditingController();
    _incomeController!.addListener(() => setState(() {}));
    return _incomeController!;
  }

  Widget _buildYesNoRadioGroup({
    required String question,
    required TextEditingController controller,
    ValueChanged<String>? onAnswerChanged,
  }) {
    final currentValue = controller.text.isEmpty ? null : controller.text;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(question, style: AppTextStyles.titleSmall),
        RadioGroup<String>(
          groupValue: currentValue,
          onChanged: (v) {
            setState(() {
              controller.text = v ?? '';
              onAnswerChanged?.call(v ?? '');
            });
          },
          child: Row(
            children: ['Não', 'Sim'].map((label) {
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    setState(() {
                      controller.text = label;
                      onAnswerChanged?.call(label);
                    });
                  },
                  child: Row(
                    children: [
                      Radio<String>(value: label),
                      Text(label, style: AppTextStyles.bodyMedium),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  bool get _canSave {
    // occupation must be selected and not 'Nenhum'
    if (_selectedOccupation == null) return false;
    if (_selectedOccupation == 'Nenhum') return false;

    // if occupation is estudante, require the user to acknowledge the info dialog
    if (_selectedOccupation == 'Estudante' && !_studentAcknowledged) {
      return false;
    }

    // if there is a detailed view model, require its controllers (fieldHints) to be filled
    if (_detailsViewModel != null) {
      // require all fieldHints controllers to be non-empty
      for (final entry in _detailsViewModel!.controllers.entries) {
        if (entry.value.text.trim().isEmpty) return false;
      }
      if (_showMovimentacaoValueField &&
          _movimentacaoValueController!.text.trim().isEmpty) {
        return false;
      }
      // if income input is shown, require it
      if (_detailsViewModel!.type != OccupationType.estudante &&
          _detailsViewModel!.type != OccupationType.estagioNaoRemunerado &&
          _detailsViewModel!.type != OccupationType.desempregado &&
          _detailsViewModel!.type != OccupationType.propietario &&
          _detailsViewModel!.type != OccupationType.doLar) {
        if (_incomeController == null ||
            _incomeController!.text.trim().isEmpty) {
          return false;
        }
      }
      if (_showUnemploymentIncomeField) {
        if (_incomeController == null ||
            _incomeController!.text.trim().isEmpty) {
          return false;
        }
      }
      return true;
    }

    // if generic label (custom occupation), require income
    if (_genericLabel != null) {
      if (_incomeController == null || _incomeController!.text.trim().isEmpty) {
        return false;
      }
      return true;
    }

    // if no specific details and not generic, still allow save when occupation selected
    return true;
  }

  final _cnpjMask = MaskTextInputFormatter(
    mask: '##.###.###/####-##',
    filter: {'#': RegExp(r'\d')},
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Ocupação'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ocupação',
                    style: AppTextStyles.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Agora nos informe algumas informações referente a ocupação e renda do membro familiar',
                    style: AppTextStyles.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 56,
                    child: InkWell(
                      onTap: _openOccupationSelector,
                      borderRadius: BorderRadius.circular(12),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          hintText: 'Selecione o tipo de ocupação',
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          suffixIcon: const Icon(
                            Icons.keyboard_arrow_down,
                          ),
                        ),
                        child: Text(
                          _selectedOccupation ?? 'Selecione o tipo de ocupação',
                          style: _selectedOccupation == null
                              ? AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.onSurface
                                      .withValues(alpha: 0.6),
                                )
                              : AppTextStyles.bodyMedium,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (_detailsViewModel != null) ...[
                    EbolsaImportantBanner(
                      title: _detailsViewModel!.title,
                      message: _detailsViewModel!.description,
                      backgroundColor: Colors.white,
                    ),
                    ..._detailsViewModel!.fieldHints.map((hint) {
                      final options = _detailsViewModel!.fieldOptions[hint];
                      if (options != null && options.isNotEmpty) {
                        final controller =
                            _detailsViewModel!.controllers[hint]!;
                        final selectedValue =
                            controller.text.isNotEmpty ? controller.text : null;
                        return _buildSearchableSelectorField(
                          label: hint,
                          selectedValue: selectedValue,
                          onTap: () => _openFieldSelector(
                            fieldLabel: hint,
                            options: options,
                            controller: controller,
                          ),
                        );
                      }

                      final isCnpj = hint == 'CNPJ';
                      final isMonetary = hint.toLowerCase().contains('valor') ||
                          hint.toLowerCase().contains('r\$');

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: EbolsaTextField(
                          controller: _detailsViewModel!.controllers[hint]!,
                          label: hint,
                          hint: hint,
                          keyboardType: isCnpj || isMonetary
                              ? const TextInputType.numberWithOptions(
                                  decimal: true)
                              : TextInputType.text,
                          inputFormatters: isCnpj
                              ? [_cnpjMask]
                              : isMonetary
                                  ? [MoneyTextInputFormatter()]
                                  : null,
                          borderRadius: 12.0,
                        ),
                      );
                    }),
                    if (_detailsViewModel!.type != OccupationType.estudante &&
                        _detailsViewModel!.type !=
                            OccupationType.estagioNaoRemunerado &&
                        _detailsViewModel!.type !=
                            OccupationType.desempregado &&
                        _detailsViewModel!.type != OccupationType.propietario &&
                        _detailsViewModel!.type != OccupationType.doLar)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: EbolsaTextField(
                          controller: _ensureIncomeController(),
                          label: 'Recebimento mensal em R\$',
                          hint: 'Recebimento mensal em R\$',
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: [MoneyTextInputFormatter()],
                          borderRadius: 12.0,
                        ),
                      ),
                    if (_detailsViewModel!.showOptanteSimples)
                      _buildYesNoRadioGroup(
                        question: 'Optante Simples nacional?',
                        controller: _detailsViewModel!
                            .controllers['Optante Simples nacional?']!,
                      ),
                    if (_detailsViewModel!.showMovimentacao) ...[
                      _buildYesNoRadioGroup(
                        question:
                            'Houve alguma movimentação na sua empresa no último ano?',
                        controller: _detailsViewModel!
                            .controllers[_movimentacaoQuestionKey]!,
                        onAnswerChanged: (answer) {
                          if (answer != 'Sim') {
                            _movimentacaoValueController?.clear();
                          }
                        },
                      ),
                      if (_showMovimentacaoValueField) ...[
                        SizedBox(
                          height: 56,
                          child: EbolsaTextField(
                            controller: _ensureMovimentacaoValueController(),
                            label: 'Informe o valor em R\$',
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            inputFormatters: [MoneyTextInputFormatter()],
                          ),
                        ),
                      ],
                    ],
                    if (_detailsViewModel!.showUnemployed)
                      _buildYesNoRadioGroup(
                        question: 'Recebe seguro desemprego?',
                        controller: _detailsViewModel!
                            .controllers['Recebe seguro desemprego?']!,
                        onAnswerChanged: (answer) {
                          if (answer != 'Sim') {
                            _incomeController?.clear();
                          }
                        },
                      ),
                    if (_showUnemploymentIncomeField)
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 16),
                        child: EbolsaTextField(
                          controller: _ensureIncomeController(),
                          label: 'Recebimento mensal em R\$',
                          hint: 'Recebimento mensal em R\$',
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: [MoneyTextInputFormatter()],
                          borderRadius: 12.0,
                        ),
                      ),
                  ] else if (_genericLabel != null) ...[
                    EbolsaImportantBanner(
                      title: _genericLabel!,
                      message: '',
                      backgroundColor: Colors.white,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: EbolsaTextField(
                        controller: _ensureIncomeController(),
                        label: 'Recebimento mensal em R\$',
                        hint: 'Recebimento mensal em R\$',
                        keyboardType: TextInputType.number,
                        borderRadius: 12.0,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 32,
        ),
        child: SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: _canSave ? _saveAndReturn : null,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  _canSave ? AppColors.primary : AppColors.dividerLight,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            child: Text(
              widget.initialOccupation != null
                  ? 'Salvar'
                  : 'Adicionar ocupação',
              style: AppTextStyles.titleMedium.copyWith(
                color: _canSave ? Colors.white : AppColors.outline,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showStudentDialog() async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundLight,
        title: Text('Atenção!', style: AppTextStyles.titleLarge),
        content: SingleChildScrollView(
          child: Text(
            'Caso o estudante exerça atividades como estagiário ou menor aprendiz, inclua uma segunda ocupação com a renda correspondente.',
            style: AppTextStyles.ebolsaBodyMedium,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _studentAcknowledged = true;
              });
              Navigator.of(context).pop();
            },
            child: Text('Estou ciente',
                style: AppTextStyles.m3LabelLarge
                    .copyWith(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}
