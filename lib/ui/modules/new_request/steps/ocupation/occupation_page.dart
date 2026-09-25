import 'package:cpf_cnpj_validator/cnpj_validator.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../../../domain/entities/enrollment_enums.dart';
import '../../../../../domain/entities/occupation_type_entity.dart';
import '../../../../components/components.dart';
import '../../../../helpers/money_text_input_formatter.dart';
import '../../../../helpers/themes/themes.dart';

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
  final Map<String, dynamic>? initialOccupationDetails;
  final String? initialMonthlyIncome;
  final List<OccupationTypeEntity> occupationTypes;
  final String? memberBirthDate;

  @override
  State<OccupationPage> createState() => _OccupationPageState();
}

class _OccupationPageState extends State<OccupationPage> {
  // IDs fixos — só para comportamentos verdadeiramente especiais
  static const _proprietarioId = '7c8efd3f-c5b1-449f-a2c2-cef814cb296e';
  static const _desempregadoId = '799d77b8-435e-4d37-bf1d-e3d68916cf4c';
  static const _estudanteId = '57e45b23-7ded-45dd-b26e-eb35baa79c90';
  static const _nenhumaId = '38bcaf6b-d485-4c47-8bff-a9db1342d12f';
  static const _autonomo = '54b67b6a-7759-49a3-9df3-c2f205bb8960';
  static const _informal = '9df23f2f-c523-4ac3-9857-e891cb6f24d8';

  // ── Estado ──────────────────────────────────────────────────
  late int _recebePensaoAlimenticia;
  late int _recebePrevidenciaPrivada;
  late int _recebeOutroBeneficioINSS;

  OccupationTypeEntity? _selectedType;
  bool _studentAcknowledged = false;

  // Controllers dinâmicos — recriados ao trocar o tipo
  TextEditingController? _incomeController;
  TextEditingController? _functionController;
  TextEditingController? _companyController;
  TextEditingController? _cnpjController;
  TextEditingController? _movimentacaoValueController;

  // Controllers de radio fixos
  final _optanteSimplesController = TextEditingController();
  final _movimentacaoController = TextEditingController();
  final _seguroDesempregoController = TextEditingController();

  // Seletores de porte/situação (Proprietário)
  CompanyType? _selectedCompanyType;
  CompanySituation? _selectedCompanySituation;

  final _cnpjMask = MaskTextInputFormatter(
    mask: '##.###.###/####-##',
    filter: {'#': RegExp(r'\d')},
  );

  // ── Getters de conveniência ──────────────────────────────────
  bool get _isNenhuma => _selectedType?.id == _nenhumaId;
  bool get _isProprietario => _selectedType?.id == _proprietarioId;
  bool get _isDesempregado => _selectedType?.id == _desempregadoId;
  bool get _isEstudante => _selectedType?.id == _estudanteId;
  bool get _isAutonomo => _selectedType?.id == _autonomo;
  bool get _isInformal => _selectedType?.id == _informal;

  // Campos baseados nos flags do endpoint
  bool get _showFunction =>
      (_selectedType?.hasFunction ?? false) && !_isNenhuma;
  bool get _showCompany =>
      (_selectedType?.hasDescription ?? false) &&
      !_isNenhuma &&
      !_isProprietario &&
      !_isAutonomo &&
      !_isInformal;

  bool get _showIncome =>
      (_selectedType?.hasIncome ?? false) &&
      !_isNenhuma &&
      !_isProprietario &&
      !_isDesempregado;

  // Campos especiais — apenas para Proprietário
  bool get _showCnpj => _isProprietario;
  bool get _showOptantesSimples => _isProprietario;
  //bool get _showMovimentacao => _isProprietario;
  bool get _showMovimentacaoValue =>
      _isProprietario && _movimentacaoController.text == 'Sim';

  // Campos especiais — apenas para Desempregado
  bool get _showSeguroDesemprego => _isDesempregado;
  bool get _showSeguroDesempregoIncome =>
      _isDesempregado && _seguroDesempregoController.text == 'Sim';

  // ── Lifecycle ────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _recebePensaoAlimenticia = widget.initialPension;
    _recebePrevidenciaPrivada = widget.initialPrevidencia;
    _recebeOutroBeneficioINSS = widget.initialInss;

    _optanteSimplesController.addListener(() => setState(() {}));
    _movimentacaoController.addListener(() => setState(() {}));
    _seguroDesempregoController.addListener(() => setState(() {}));

    if (widget.initialOccupation != null && widget.occupationTypes.isNotEmpty) {
      _selectedType = widget.occupationTypes
          .firstWhereOrNull((t) => t.name == widget.initialOccupation);
      _rebuildControllers();

      final d = widget.initialOccupationDetails ?? {};
      _functionController?.text = d['Função']?.toString() ?? '';
      _companyController?.text = d['Empresa']?.toString() ?? '';
      _cnpjController?.text = d['CNPJ']?.toString() ?? '';
      _optanteSimplesController.text =
          d['Optante Simples nacional?']?.toString() ?? '';
      _movimentacaoController.text = d['Houve movimentacao?']?.toString() ?? '';
      _seguroDesempregoController.text =
          d['Recebe seguro desemprego?']?.toString() ?? '';

      final companyTypeRaw = d['companyType'];
      if (companyTypeRaw != null) {
        _selectedCompanyType =
            CompanyType.fromValue(int.tryParse(companyTypeRaw.toString()) ?? 0);
      }
      final situacaoRaw = d['situation'];
      if (situacaoRaw != null) {
        _selectedCompanySituation = CompanySituation.fromValue(
            int.tryParse(situacaoRaw.toString()) ?? 0);
      }

      if (_showMovimentacaoValue) {
        _movimentacaoValueController ??= TextEditingController()
          ..addListener(() => setState(() {}));
        _movimentacaoValueController!.text =
            d['Valor movimentacao']?.toString() ?? '';
      }

      if (widget.initialMonthlyIncome != null && _incomeController != null) {
        _incomeController!.text = widget.initialMonthlyIncome!;
      }

      _studentAcknowledged = _isEstudante;
    }
  }

  @override
  void dispose() {
    _incomeController?.dispose();
    _functionController?.dispose();
    _companyController?.dispose();
    _cnpjController?.dispose();
    _movimentacaoValueController?.dispose();
    _optanteSimplesController.dispose();
    _movimentacaoController.dispose();
    _seguroDesempregoController.dispose();
    super.dispose();
  }

  void _rebuildControllers() {
    _incomeController?.dispose();
    _functionController?.dispose();
    _companyController?.dispose();
    _cnpjController?.dispose();
    _movimentacaoValueController?.dispose();

    _functionController = _showFunction
        ? (TextEditingController()..addListener(() => setState(() {})))
        : null;
    _companyController = _showCompany
        ? (TextEditingController()..addListener(() => setState(() {})))
        : null;
    _cnpjController = _showCnpj
        ? (TextEditingController()
          ..addListener(() {
            setState(() {});
            _validateCnpj();
          }))
        : null;
    _incomeController = (_showIncome || _showSeguroDesemprego)
        ? (TextEditingController()..addListener(() => setState(() {})))
        : null;
    _movimentacaoValueController = _isProprietario
        ? (TextEditingController()..addListener(() => setState(() {})))
        : null;

    _optanteSimplesController.clear();
    _movimentacaoController.clear();
    _seguroDesempregoController.clear();
    _selectedCompanyType = null;
    _selectedCompanySituation = null;
  }

  String? _cnpjError;

  void _validateCnpj() {
    final clean = _cnpjController?.text.replaceAll(RegExp(r'\D'), '') ?? '';
    if (clean.length < 14) {
      setState(() => _cnpjError = null); // ainda digitando, sem erro
      return;
    }
    setState(() {
      _cnpjError = CNPJValidator.isValid(clean) ? null : 'CNPJ inválido';
    });
  }

  // ── Validação ────────────────────────────────────────────────
  bool get _canSave {
    if (_selectedType == null) return false;
    if (_isNenhuma) return true;
    if (_isEstudante && !_studentAcknowledged) return false;

    if (_showFunction && (_functionController?.text.trim().isEmpty ?? true)) {
      return false;
    }
    if (_showCompany && (_companyController?.text.trim().isEmpty ?? true)) {
      return false;
    }

    // Proprietário
    if (_showCnpj) {
      if (_cnpjController?.text.trim().isEmpty ?? true) return false;
      if (_selectedCompanyType == null) return false;
      if (_selectedCompanySituation == null) return false;
      if (_optanteSimplesController.text.isEmpty) return false;
      if (_movimentacaoController.text.isEmpty) return false;
      if ((_showMovimentacaoValue &&
              ((_movimentacaoValueController?.text.trim().isEmpty) ?? true)) ||
          _movimentacaoValueController?.text == '0,00') {
        return false;
      }
    }

    // Renda regular
    if ((_showIncome && (_incomeController?.text.trim().isEmpty ?? true)) ||
        _incomeController?.text == '0,00') {
      return false;
    }

    // Desempregado
    if (_showSeguroDesemprego && _seguroDesempregoController.text.isEmpty) {
      return false;
    }
    if (_showSeguroDesempregoIncome &&
        (_incomeController?.text.trim().isEmpty ?? true)) {
      return false;
    }

    return true;
  }

  // ── Salvar ───────────────────────────────────────────────────
  void _saveAndReturn() {
    final details = <String, dynamic>{};

    if (_functionController != null) {
      details['Função'] = _functionController!.text;
      details['Função/Atuação'] = _functionController!.text;
    }
    if (_companyController != null) {
      details['Empresa'] = _companyController!.text;
    }
    if (_cnpjController != null) details['CNPJ'] = _cnpjController!.text;
    if (_selectedCompanyType != null) {
      details['companyTypeLabel'] = _selectedCompanyType!.label;
      details['companyType'] = _selectedCompanyType!.value;
    }
    if (_selectedCompanySituation != null) {
      details['Situação'] = _selectedCompanySituation!.label;
      details['situation'] = _selectedCompanySituation!.value;
    }
    if (_optanteSimplesController.text.isNotEmpty) {
      details['Optante Simples nacional?'] = _optanteSimplesController.text;
    }
    if (_movimentacaoController.text.isNotEmpty) {
      details['Houve movimentacao?'] = _movimentacaoController.text;
    }
    if (_movimentacaoValueController != null) {
      details['Valor movimentacao'] = _movimentacaoValueController!.text;
    }
    if (_seguroDesempregoController.text.isNotEmpty) {
      details['Recebe seguro desemprego?'] = _seguroDesempregoController.text;
    }

    // Renda mensal
    final income = _showMovimentacaoValue
        ? (_movimentacaoValueController?.text ?? '0')
        : (_incomeController?.text ?? '0');

    Navigator.of(context).pop({
      'pension': _recebePensaoAlimenticia,
      'previdencia': _recebePrevidenciaPrivada,
      'inss': _recebeOutroBeneficioINSS,
      'occupation': _selectedType?.name,
      'ocupationTypeId': _selectedType?.id,
      'occupationTypeId': _selectedType?.id,
      'monthlyIncome': income,
      'function': _functionController?.text,
      'companyName': _companyController?.text,
      'cnpj': _cnpjController?.text,
      'companyType': _selectedCompanyType?.value,
      'situation': _selectedCompanySituation?.value,
      'hadActivityLastYear': _movimentacaoController.text == 'Sim',
      'simplesNacionalTax': _optanteSimplesController.text == 'Sim',
      'unemploymentInsurance': _seguroDesempregoController.text == 'Sim',
      'occupationDetails': details,
    });
  }

  // ── Seleção de tipo ─────────────────────────────────────────
  Future<void> _openOccupationSelector() async {
    final selected =
        await SearchableOptionsBottomSheet.show<OccupationTypeEntity>(
      context: context,
      title: 'Selecione o tipo de ocupação',
      options: widget.occupationTypes,
      searchHint: 'Pesquisar',
      helperText: '',
      emptyStateText: 'Nenhum resultado',
      closeTooltip: 'Fechar',
      selectedValue: _selectedType,
      labelBuilder: (t) => t.name ?? '',
      searchTextBuilder: (t) => t.name ?? '',
      showSearchInput: false,
    );

    if (selected == null || !mounted) return;

    setState(() {
      _selectedType = selected;
      _studentAcknowledged = false;
      _rebuildControllers();
    });

    if (_isEstudante) await _showStudentDialog();
  }

  // ── Helpers de UI ────────────────────────────────────────────
  Widget _buildYesNoRadioGroup({
    required String question,
    required TextEditingController controller,
    ValueChanged<String>? onAnswerChanged,
  }) {
    final currentValue = controller.text.isEmpty ? null : controller.text;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question, style: AppTextStyles.titleSmall),
          const SizedBox(height: 4),
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
      ),
    );
  }

  Future<void> _openEnumSelector<T>({
    required String title,
    required List<T> options,
    required T? selectedValue,
    required String Function(T) labelBuilder,
    required void Function(T) onSelected,
  }) async {
    final selected = await SearchableOptionsBottomSheet.show<T>(
      context: context,
      title: title,
      options: options,
      searchHint: 'Pesquisar',
      helperText: '',
      emptyStateText: 'Nenhum resultado',
      closeTooltip: 'Fechar',
      selectedValue: selectedValue,
      labelBuilder: labelBuilder,
      searchTextBuilder: labelBuilder,
      showSearchInput: false,
    );
    if (selected != null && mounted) setState(() => onSelected(selected));
  }

  Widget _buildEnumSelectorField<T>({
    required String label,
    required T? selectedValue,
    required String Function(T) labelBuilder,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        ),
        child: Text(
          selectedValue != null ? labelBuilder(selectedValue) : label,
          style: selectedValue == null
              ? AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.onSurface.withValues(alpha: 0.6))
              : AppTextStyles.bodyMedium,
        ),
      ),
    );
  }

  // ── Dialog estudante ─────────────────────────────────────────
  Future<void> _showStudentDialog() async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundLight,
        title: Text('Atenção!', style: AppTextStyles.titleLarge),
        content: SingleChildScrollView(
          child: Text(
            'Caso o estudante exerça atividades como estagiário ou menor '
            'aprendiz, inclua uma segunda ocupação com a renda correspondente.',
            style: AppTextStyles.ebolsaBodyMedium,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() => _studentAcknowledged = true);
              Navigator.of(context).pop();
            },
            child: Text(
              'Estou ciente',
              style:
                  AppTextStyles.m3LabelLarge.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  // ── Build ────────────────────────────────────────────────────
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Ocupação', style: AppTextStyles.titleLarge),
              const SizedBox(height: 8),
              Text(
                'Agora nos informe algumas informações referente a '
                'ocupação e renda do membro familiar',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 24),

              // ── Seletor de tipo ────────────────────────────────
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
                          horizontal: 12, vertical: 16),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      suffixIcon: const Icon(Icons.keyboard_arrow_down),
                    ),
                    child: Text(
                      _selectedType?.name ?? 'Selecione o tipo de ocupação',
                      style: _selectedType == null
                          ? AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.onSurface.withValues(alpha: 0.6))
                          : AppTextStyles.bodyMedium,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // ── Campos dinâmicos ───────────────────────────────
              if (_selectedType != null) ...[
                // Descrição do tipo
                if (_selectedType!.description?.isNotEmpty == true) ...[
                  EbolsaImportantBanner(
                    title: _selectedType!.name ?? '',
                    message: _selectedType!.description!,
                    backgroundColor: Colors.white,
                  ),
                  const SizedBox(height: 16),
                ],

                // 2.2 Assalariado / 2.4 Autônomo+Informal / 2.5 Estágio Rem. / Aprendiz
                // Ordem: Função → Empresa → Renda
                if (_showFunction && !_showCnpj) ...[
                  EbolsaTextField(
                    controller: _functionController!,
                    label: 'Função',
                    hint: 'Função',
                    borderRadius: 12.0,
                  ),
                  const SizedBox(height: 16),
                ],
                if (_showCompany) ...[
                  EbolsaTextField(
                    controller: _companyController!,
                    label: 'Empresa',
                    hint: 'Empresa',
                    borderRadius: 12.0,
                  ),
                  const SizedBox(height: 16),
                ],

                // 2.3 Proprietário — ordem: CNPJ → Porte → Situação → Função
                //                            → Optante Simples → Movimentação → Valor
                if (_showCnpj) ...[
                  EbolsaTextField(
                    controller: _cnpjController!,
                    label: 'CNPJ',
                    hint: '00.000.000/0000-00',
                    keyboardType: TextInputType.number,
                    inputFormatters: [_cnpjMask],
                    borderRadius: 12.0,
                    errorText: _cnpjError,
                  ),
                  const SizedBox(height: 16),
                  _buildEnumSelectorField<CompanyType>(
                    label: 'Porte da empresa',
                    selectedValue: _selectedCompanyType,
                    labelBuilder: (t) => t.label,
                    onTap: () => _openEnumSelector<CompanyType>(
                      title: 'Porte da empresa',
                      options: CompanyType.values,
                      selectedValue: _selectedCompanyType,
                      labelBuilder: (t) => t.label,
                      onSelected: (v) => _selectedCompanyType = v,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildEnumSelectorField<CompanySituation>(
                    label: 'Situação',
                    selectedValue: _selectedCompanySituation,
                    labelBuilder: (s) => s.label,
                    onTap: () => _openEnumSelector<CompanySituation>(
                      title: 'Situação',
                      options: CompanySituation.values,
                      selectedValue: _selectedCompanySituation,
                      labelBuilder: (s) => s.label,
                      onSelected: (v) => _selectedCompanySituation = v,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Função do Proprietário
                  if (_showFunction) ...[
                    EbolsaTextField(
                      controller: _functionController!,
                      label: 'Função/Atuação',
                      hint: 'Função/Atuação',
                      borderRadius: 12.0,
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (_showOptantesSimples)
                    _buildYesNoRadioGroup(
                      question: 'Optante Simples nacional?',
                      controller: _optanteSimplesController,
                    ),
                  _buildYesNoRadioGroup(
                    question:
                        'Houve alguma movimentação na sua empresa no último ano?',
                    controller: _movimentacaoController,
                    onAnswerChanged: (v) {
                      if (v != 'Sim') _movimentacaoValueController?.clear();
                    },
                  ),
                  if (_showMovimentacaoValue) ...[
                    SizedBox(
                      height: 56,
                      child: EbolsaTextField(
                        controller: _movimentacaoValueController!,
                        label: 'Informe o valor em R\$',
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [MoneyTextInputFormatter()],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ],

                // 2.4 Autônomo/Informal / 2.2 Assalariado / 2.5 Estágio / 2.6 Aposentado+BPC
                // Renda mensal regular
                if (_showIncome) ...[
                  EbolsaTextField(
                    controller: _incomeController!,
                    label: 'Recebimento mensal em R\$',
                    hint: 'Recebimento mensal em R\$',
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [MoneyTextInputFormatter()],
                    borderRadius: 12.0,
                  ),
                  const SizedBox(height: 16),
                ],

                // 2.7 Desempregado
                if (_showSeguroDesemprego) ...[
                  _buildYesNoRadioGroup(
                    question: 'Recebe seguro desemprego?',
                    controller: _seguroDesempregoController,
                    onAnswerChanged: (v) {
                      if (v != 'Sim') _incomeController?.clear();
                    },
                  ),
                  if (_showSeguroDesempregoIncome) ...[
                    EbolsaTextField(
                      controller: _incomeController!,
                      label: 'Valor do seguro desemprego em R\$',
                      hint: 'Valor do seguro desemprego em R\$',
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [MoneyTextInputFormatter()],
                      borderRadius: 12.0,
                    ),
                    const SizedBox(height: 16),
                  ],
                ],
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: _canSave ? _saveAndReturn : null,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  _canSave ? AppColors.primary : AppColors.dividerLight,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28)),
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
}

extension _FirstWhereOrNull<E> on List<E> {
  E? firstWhereOrNull(bool Function(E) test) {
    for (final e in this) {
      if (test(e)) return e;
    }
    return null;
  }
}
