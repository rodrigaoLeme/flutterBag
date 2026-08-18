import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../main/i18n/app_i18n.dart';
import '../../../../components/components.dart';
import '../../../../helpers/themes/themes.dart';

class OtherIncomeTypeConfig {
  const OtherIncomeTypeConfig({
    required this.details,
    this.requiresDescription = false,
    this.useIncomeValueLabel = false,
  });

  final String details;
  final bool requiresDescription;
  final bool useIncomeValueLabel;
}

class OtherIncomeSourcePage extends StatefulWidget {
  const OtherIncomeSourcePage({
    super.key,
    this.initialType,
    this.initialMonthlyIncome,
    this.initialDescription,
  });

  final String? initialType;
  final String? initialMonthlyIncome;
  final String? initialDescription;

  static const incomeTypes = [
    'Aluguéis, Inclusive por Temporada',
    'Beneficiária de Algum Programa do Governo',
    'Pensão Alimentícia',
    'Ajuda Financeira',
    'Benefício/ Auxílio do INSS',
    'Previdência Privada',
    'Bolsas de Estudo e de Pesquisa',
    'Ganho de Capital na Venda de Imóveis/Móveis',
    'Ganhos Líquidos em Operações no Mercado de Ações',
    'Prêmios Líquidos Obtidos em Loterias e/ou Apostas',
    'Rendimentos de Aplicações Financeiras',
    'Rendimentos de Plataformas Digitais',
  ];

  static const incomeTypesWithAverageAlert = {
    'Aluguéis, Inclusive por Temporada',
    'Beneficiária de Algum Programa do Governo',
    'Ajuda Financeira',
    'Bolsas de Estudo e de Pesquisa',
    'Ganho de Capital na Venda de Imóveis/Móveis',
    'Prêmios Líquidos Obtidos em Loterias e/ou Apostas',
    'Rendimentos de Aplicações Financeiras',
    'Rendimentos de Plataformas Digitais',
  };

  static const typeConfigs = {
    'Aluguéis, Inclusive por Temporada': OtherIncomeTypeConfig(
      details:
          'Valores recebidos pelo aluguel de casas, apartamentos, salas comerciais, terrenos, imóveis por temporada ou qualquer outro tipo de imóvel.',
    ),
    'Beneficiária de Algum Programa do Governo': OtherIncomeTypeConfig(
      details: 'texto API',
      requiresDescription: true,
    ),
    'Pensão Alimentícia': OtherIncomeTypeConfig(
      details:
          'Valores recebidos regularmente como pensão alimentícia, seja por acordo informal, decisão judicial ou outro tipo de obrigação familiar.',
      useIncomeValueLabel: true,
    ),
    'Ajuda Financeira': OtherIncomeTypeConfig(
      details: 'texto API',
      requiresDescription: true,
    ),
    'Benefício/ Auxílio do INSS': OtherIncomeTypeConfig(
      details:
          'Valores recebidos do INSS, como aposentadoria, pensão, auxílio-doença, BPC/LOAS ou outros benefícios previdenciários ou assistenciais.',
      requiresDescription: true,
      useIncomeValueLabel: true,
    ),
    'Previdência Privada': OtherIncomeTypeConfig(
      details:
          'Valores recebidos regularmente como pensão alimentícia, seja por acordo informal, decisão judicial ou outro tipo de obrigação familiar.',
      useIncomeValueLabel: true,
    ),
    'Bolsas de Estudo e de Pesquisa': OtherIncomeTypeConfig(
      details: 'texto API',
      requiresDescription: true,
    ),
    'Ganho de Capital na Venda de Imóveis/Móveis': OtherIncomeTypeConfig(
      details: 'texto API',
      requiresDescription: true,
    ),
    'Ganhos Líquidos em Operações no Mercado de Ações': OtherIncomeTypeConfig(
      details:
          'Valores recebidos regularmente como pensão alimentícia, seja por acordo informal, decisão judicial ou outro tipo de obrigação familiar.',
      useIncomeValueLabel: true,
    ),
    'Prêmios Líquidos Obtidos em Loterias e/ou Apostas': OtherIncomeTypeConfig(
      details: 'texto API',
      requiresDescription: true,
    ),
    'Rendimentos de Aplicações Financeiras': OtherIncomeTypeConfig(
      details: 'texto API',
      requiresDescription: true,
    ),
    'Rendimentos de Plataformas Digitais': OtherIncomeTypeConfig(
      details: 'texto API',
      requiresDescription: true,
    ),
  };

  @override
  State<OtherIncomeSourcePage> createState() => _OtherIncomeSourcePageState();
}

class _OtherIncomeSourcePageState extends State<OtherIncomeSourcePage> {
  String? _selectedType;
  late final TextEditingController _monthlyIncomeController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialType;
    _monthlyIncomeController = TextEditingController(
      text: widget.initialMonthlyIncome ?? '',
    );
    _descriptionController = TextEditingController(
      text: widget.initialDescription ?? '',
    );
    _monthlyIncomeController.addListener(_onFieldsChanged);
    _descriptionController.addListener(_onFieldsChanged);
  }

  @override
  void dispose() {
    _monthlyIncomeController
      ..removeListener(_onFieldsChanged)
      ..dispose();
    _descriptionController
      ..removeListener(_onFieldsChanged)
      ..dispose();
    super.dispose();
  }

  void _onFieldsChanged() => setState(() {});

  OtherIncomeTypeConfig? get _selectedConfig => _selectedType == null
      ? null
      : OtherIncomeSourcePage.typeConfigs[_selectedType];

  OtherIncomeTypeConfig get _effectiveConfig =>
      _selectedConfig ??
      const OtherIncomeTypeConfig(
        details: 'texto API',
        requiresDescription: true,
      );

  bool get _requiresDescription => _effectiveConfig.requiresDescription;

  bool get _canAdd {
    if (_selectedType == null) return false;
    if (_monthlyIncomeController.text.trim().isEmpty) return false;
    if (_requiresDescription && _descriptionController.text.trim().isEmpty) {
      return false;
    }
    return true;
  }

  Future<void> _showAverageIncomeAlertIfNeeded(String type) async {
    if (!OtherIncomeSourcePage.incomeTypesWithAverageAlert.contains(type)) {
      return;
    }
    if (!mounted) return;

    final i18n = AppI18n.current;
    await EbolsaDialog.show(
      context: context,
      title: i18n.familyConfirmDialogTitle,
      description: i18n.otherIncomeAverageAlertDescription,
      actions: [
        EbolsaDialogAction(
          label: i18n.okAction,
          onPressed: () {},
        ),
      ],
    );
  }

  Future<void> _openTypeSelector() async {
    final i18n = AppI18n.current;
    final selected = await SearchableOptionsBottomSheet.show<String>(
      context: context,
      title: i18n.selectIncomeTypeLabel,
      options: OtherIncomeSourcePage.incomeTypes,
      searchHint: i18n.noticesTermsSearchHint,
      helperText: i18n.noticesTermsBottomSheetSearchHelp,
      emptyStateText: i18n.noticesTermsBottomSheetNoResults,
      closeTooltip: i18n.noticesTermsCloseAction,
      selectedValue: _selectedType,
    );
    if (selected == null || !mounted) return;

    final typeChanged = selected != _selectedType;
    setState(() {
      _selectedType = selected;
      if (typeChanged) {
        _monthlyIncomeController.clear();
        _descriptionController.clear();
      }
    });
    await _showAverageIncomeAlertIfNeeded(selected);
    if (mounted) setState(() {});
  }

  void _addAndReturn() {
    if (!_canAdd) return;
    Navigator.of(context).pop({
      'type': _selectedType,
      'monthlyIncome': _monthlyIncomeController.text.trim(),
      if (_requiresDescription)
        'description': _descriptionController.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final i18n = AppI18n.current;
    final config = _effectiveConfig;
    final hasSelection = _selectedType != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(i18n.otherIncomeSourcePageAppBarTitle),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              i18n.otherIncomeSourcesInfoTitle,
              style: AppTextStyles.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              i18n.otherIncomeMemberStepDescription,
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 56,
              child: InkWell(
                onTap: _openTypeSelector,
                borderRadius: BorderRadius.circular(12),
                child: InputDecorator(
                  decoration: InputDecoration(
                    hintText: i18n.selectIncomeTypeLabel,
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
                    _selectedType ?? i18n.selectIncomeTypeLabel,
                    style: _selectedType == null
                        ? AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.onSurface.withValues(alpha: 0.6),
                          )
                        : AppTextStyles.bodyMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            if (hasSelection) ...[
              const SizedBox(height: 24),
              EbolsaImportantBanner(
                title: _selectedType!,
                message:
                    '${i18n.otherIncomeSelectedDetailsPrefix}${config.details}',
                backgroundColor: Colors.white,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: EbolsaTextField(
                  controller: _monthlyIncomeController,
                  label: config.useIncomeValueLabel
                      ? i18n.otherIncomeValueLabel
                      : i18n.otherIncomeMonthlyAverageLabel,
                  hint: config.useIncomeValueLabel
                      ? i18n.otherIncomeValueLabel
                      : i18n.otherIncomeMonthlyAverageLabel,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                  ],
                  borderRadius: 12,
                ),
              ),
              if (config.requiresDescription)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: TextField(
                    controller: _descriptionController,
                    minLines: 3,
                    maxLines: 5,
                    style: AppTextStyles.bodyLarge,
                    onChanged: (_) => _onFieldsChanged(),
                    decoration: InputDecoration(
                      labelText: i18n.descriptionLabel,
                      hintText: i18n.descriptionLabel,
                      alignLabelWithHint: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: _canAdd ? _addAndReturn : null,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  _canAdd ? AppColors.primary : AppColors.dividerLight,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            child: Text(
              i18n.addIncomeSourceAction,
              style: AppTextStyles.ebolsaTitleMedium.copyWith(
                color: _canAdd ? Colors.white : AppColors.outline,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
