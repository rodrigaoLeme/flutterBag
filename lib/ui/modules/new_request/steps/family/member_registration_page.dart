import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../main/i18n/app_i18n.dart';
import '../../../../components/ebolsa_member_card.dart';
import '../../../../components/ebolsa_step_header.dart';
import '../../../../helpers/themes/themes.dart';
import 'member_registration_view_model.dart';
import 'member_registration_sub_step_config.dart';
import 'own_property_page.dart';
import 'financial_investment_page.dart';
import 'vehicle_page.dart';
import '../../../../components/components.dart';
import '../../../../helpers/themes/themes.dart';
import '../../widgets/scholarship_step_indicator.dart';
import '../ocupation/occupation_page.dart';
import 'member_registration_view_model.dart';

const String kAdvanceToExpensesResult = 'advanceToExpenses';

class MemberRegistrationPage extends StatefulWidget {
  const MemberRegistrationPage({super.key});

  @override
  State<MemberRegistrationPage> createState() => _MemberRegistrationPageState();
}

class _MemberRegistrationPageState extends State<MemberRegistrationPage> {
  late final MemberRegistrationViewModel _vm;
  int _currentSubStep = 1;
  static const int _totalSubSteps = memberRegistrationSubStepCount;
  static const double _minimumWage = 1518.0;
  late final ScrollController _scrollController;
  // Local state for substep 2 (occupation) questions
  int _recebePensaoAlimenticia = 0;
  int _recebePrevidenciaPrivada = 0;
  int _recebeOutroBeneficioINSS = 0;
  int _possuiTEA = 0;
  bool _hasOccupation = false;
  bool _showPensionNisField = false;
  late final TextEditingController _pensionValueController;
  late final TextEditingController _previdenciaValueController;
  late final TextEditingController _beneficioValueController;
  bool _showPrevidenciaValueField = false;
  bool _showInssValueField = false;
  int _recebeValorImovelAlugado = 0;
  int _ajudaFinanceira = 0;
  int _beneficiarioProgramaGoverno = 0;
  int _possuiImovelProprio = 0;
  int _possuiInvestimentoFinanceiro = 0;
  int _possuiVeiculo = 0;
  late final TextEditingController _imovelAlugadoValueController;
  late final TextEditingController _ajudaFamiliarValueController;
  late final TextEditingController _ajudaOutroDeQuemController;
  late final TextEditingController _ajudaOutroValueController;
  late final TextEditingController _programaGovernoController;
  late final TextEditingController _programaGovernoValueController;
  final List<Map<String, dynamic>> _addedOccupations = [];
  final List<Map<String, dynamic>> _addedFamilyMembers = [];
  final List<Map<String, dynamic>> _addedProperties = [];
  final List<Map<String, dynamic>> _addedInvestments = [];
  final List<Map<String, dynamic>> _addedVehicles = [];

  @override
  void dispose() {
    _scrollController.dispose();
    _pensionValueController.dispose();
    _previdenciaValueController.dispose();
    _beneficioValueController.dispose();
    _imovelAlugadoValueController.dispose();
    _ajudaFamiliarValueController.dispose();
    _ajudaOutroDeQuemController.dispose();
    _ajudaOutroValueController.dispose();
    _programaGovernoController.dispose();
    _programaGovernoValueController.dispose();
    _vm.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _vm = MemberRegistrationViewModel();
    _vm.addListener(() => setState(() {}));
    _pensionValueController = TextEditingController();
    _previdenciaValueController = TextEditingController();
    _beneficioValueController = TextEditingController();
    _imovelAlugadoValueController = TextEditingController();
    _ajudaFamiliarValueController = TextEditingController();
    _ajudaOutroDeQuemController = TextEditingController();
    _ajudaOutroValueController = TextEditingController();
    _programaGovernoController = TextEditingController();
    _programaGovernoValueController = TextEditingController();
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

  Future<void> _openNationalitySelector() async {
    final appStrings = AppI18n.current;
    final selected = await SearchableOptionsBottomSheet.show<String>(
      context: context,
      title: appStrings.nationalityLabel,
      options: _vm.nationalityOptions,
      searchHint: appStrings.noticesTermsSearchHint,
      helperText: appStrings.noticesTermsBottomSheetSearchHelp,
      emptyStateText: appStrings.noticesTermsBottomSheetNoResults,
      closeTooltip: appStrings.noticesTermsCloseAction,
      selectedValue: _vm.nacionalityController.text.isNotEmpty
          ? _vm.nacionalityController.text
          : null,
    );
    if (selected != null) {
      setState(() {
        _vm.nacionalityController.text = selected;
      });
    }
  }

  Future<void> _openPcdSelector() async {
    final appStrings = AppI18n.current;
    final selected = await SearchableOptionsBottomSheet.show<String>(
      context: context,
      title: appStrings.pcdLabel,
      options: _vm.pcdOptions,
      searchHint: appStrings.noticesTermsSearchHint,
      helperText: appStrings.noticesTermsBottomSheetSearchHelp,
      emptyStateText: appStrings.noticesTermsBottomSheetNoResults,
      closeTooltip: appStrings.noticesTermsCloseAction,
      selectedValue: _vm.selectedPcd,
    );
    if (selected != null) {
      setState(() {
        _vm.selectedPcd = selected;
      });
    }
  }

  Future<void> _showPensionDialog() async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundLight,
        title: Text(
          'Atenção!',
          style: AppTextStyles.titleLarge,
        ),
        content: SingleChildScrollView(
          child: Text(
            'Caso você receba a pensão em seu nome, mas esse benefício seja para outro(s) integrante(s) do grupo familiar, gentileza informar esse valor no cadastro dele(s).\n\n'
            'Caso receba um único valor de pensão para mais de um integrante do grupo familiar, divida essa quantia pelo número de pessoas beneficiadas por ela, e informe a parte (valor) correspondente no cadastro de cada um deles. (Ex.: Recebe R\$ 900,00 reais de pensão para 3 filhos, informe R\$ 300,00 reais no cadastro de cada um deles.)\n\n'
            'Insira o valor da pensão apenas para os membros da família que recebem este benefício.\n\n'
            'O comprovante de recebimento da pensão será gerado individualmente para todos aqueles que selecionarem a opção "sim". Caso você possua um único comprovante ou única declaração deste valor, insira o mesmo documento para todos os beneficiários.',
            style: AppTextStyles.ebolsaBodyMedium,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              AppI18n.current.createAccountDialogDoneButton,
              style: AppTextStyles.m3LabelLarge,
              selectionColor: AppColors.textButton,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onRecebePensaoChanged(int? v) async {
    if (v == null) return;
    if (v == 1) {
      await _showPensionDialog();
      setState(() {
        _recebePensaoAlimenticia = 1;
        _showPensionNisField = true;
        // ensure we also mark previdencia value hidden unless explicitly set
        _showPrevidenciaValueField = _showPrevidenciaValueField;
      });
    } else {
      setState(() {
        _recebePensaoAlimenticia = 0;
        _showPensionNisField = false;
      });
    }
  }

  void _onRecebePrevidenciaChanged(int? v) {
    setState(() {
      _recebePrevidenciaPrivada = v ?? 0;
      _showPrevidenciaValueField = _recebePrevidenciaPrivada == 1;
    });
  }

  Future<void> _showInssDialog() async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundLight,
        title: Text(
          'Atenção!',
          style: AppTextStyles.titleLarge,
        ),
        content: SingleChildScrollView(
          child: Text(
            'Em caso de “Aposentado e/ou Pensionista” ou “Beneficiário(a) de Prestação Continuada (BPC)”, insira o valor recebido em ocupações. Caso contrário, poderá ser adicionado aqui o valor correspondente à: Auxílio-Doença, Auxílio-Acidente, Auxílio-Reclusão, Auxílio-Doença da Aeronauta Gestante, Benefício ao Trabalhador Portuário Avulso, Salário-Maternidade, Salário Família, Seguro-Defeso Pescador Artesanal ou outro.',
            style: AppTextStyles.ebolsaBodyMedium,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              AppI18n.current.createAccountDialogDoneButton,
              style: AppTextStyles.m3LabelLarge,
              selectionColor: AppColors.textButton,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onRecebeInssChanged(int? v) async {
    if (v == null) return;
    if (v == 1) {
      await _showInssDialog();
      setState(() {
        _recebeOutroBeneficioINSS = 1;
        _showInssValueField = true;
      });
    } else {
      setState(() {
        _recebeOutroBeneficioINSS = 0;
        _showInssValueField = false;
      });
    }
  }

  void _onRecebeValorImovelAlugadoChanged(int? v) {
    setState(() {
      _recebeValorImovelAlugado = v ?? 0;
      if (_recebeValorImovelAlugado != 1) {
        _imovelAlugadoValueController.clear();
      }
    });
  }

  void _onAjudaFinanceiraChanged(int? v) {
    setState(() {
      _ajudaFinanceira = v ?? 0;
      if (_ajudaFinanceira != 1) {
        _ajudaFamiliarValueController.clear();
      }
      if (_ajudaFinanceira != 2) {
        _ajudaOutroDeQuemController.clear();
        _ajudaOutroValueController.clear();
      }
    });
  }

  void _onBeneficiarioProgramaGovernoChanged(int? v) {
    setState(() {
      _beneficiarioProgramaGoverno = v ?? 0;
      if (_beneficiarioProgramaGoverno != 1) {
        _programaGovernoController.clear();
        _programaGovernoValueController.clear();
      }
    });
  }

  void _onPossuiImovelProprioChanged(int? v) {
    setState(() {
      _possuiImovelProprio = v ?? 0;
      if (_possuiImovelProprio != 1) {
        _addedProperties.clear();
      }
    });
  }

  Future<void> _openOwnPropertyForm({int? editIndex}) async {
    Map<String, dynamic>? initial;
    if (editIndex != null) {
      initial = _addedProperties[editIndex];
    }

    final res = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(
        builder: (_) => OwnPropertyPage(
          initialType: initial?['type'] as String?,
          initialInstallmentValue: initial?['installmentValue'] as String?,
          initialAssetValue: initial?['assetValue'] as String?,
        ),
      ),
    );

    if (res == null || !mounted) return;

    setState(() {
      if (editIndex != null) {
        _addedProperties[editIndex] = res;
      } else {
        _addedProperties.add(res);
      }
    });
  }

  void _onPossuiInvestimentoFinanceiroChanged(int? v) {
    setState(() {
      _possuiInvestimentoFinanceiro = v ?? 0;
      if (_possuiInvestimentoFinanceiro != 1) {
        _addedInvestments.clear();
      }
    });
  }

  Future<void> _openFinancialInvestmentForm({int? editIndex}) async {
    Map<String, dynamic>? initial;
    if (editIndex != null) {
      initial = _addedInvestments[editIndex];
    }

    final res = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(
        builder: (_) => FinancialInvestmentPage(
          initialType: initial?['type'] as String?,
          initialValue: initial?['value'] as String?,
        ),
      ),
    );

    if (res == null || !mounted) return;

    setState(() {
      if (editIndex != null) {
        _addedInvestments[editIndex] = res;
      } else {
        _addedInvestments.add(res);
      }
    });
  }

  void _onPossuiVeiculoChanged(int? v) {
    setState(() {
      _possuiVeiculo = v ?? 0;
      if (_possuiVeiculo != 1) {
        _addedVehicles.clear();
      }
    });
  }

  Future<void> _openVehicleForm({int? editIndex}) async {
    Map<String, dynamic>? initial;
    if (editIndex != null) {
      initial = _addedVehicles[editIndex];
    }

    final res = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(
        builder: (_) => VehiclePage(
          initialBrand: initial?['brand'] as String?,
          initialModel: initial?['model'] as String?,
          initialYear: initial?['year'] as String?,
          initialInstallmentValue: initial?['installmentValue'] as String?,
          initialAssetValue: initial?['assetValue'] as String?,
        ),
      ),
    );

    if (res == null || !mounted) return;

    setState(() {
      if (editIndex != null) {
        _addedVehicles[editIndex] = res;
      } else {
        _addedVehicles.add(res);
      }
    });
  }

  String _formatCurrency(dynamic value) {
    try {
      if (value == null) return '';
      if (value is num) {
        return NumberFormat.simpleCurrency(locale: 'pt_BR', decimalDigits: 2)
            .format(value);
      }
      if (value is String) {
        final cleaned = value.replaceAll(RegExp(r'[^0-9,\.]'), '');
        final normalized = cleaned.replaceAll(',', '.');
        final parsed = double.tryParse(normalized);
        if (parsed != null) {
          return NumberFormat.simpleCurrency(locale: 'pt_BR', decimalDigits: 2)
              .format(parsed);
        }
        return value;
      }
      return value.toString();
    } catch (_) {
      return value.toString();
    }
  }

  double _parseMoneyValue(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    if (value is String) {
      final cleaned = value.replaceAll(RegExp(r'[^0-9,\.]'), '');
      final normalized = cleaned.replaceAll(',', '.');
      return double.tryParse(normalized) ?? 0;
    }
    return 0;
  }

  double _computeGrossFamilyIncome() {
    var total = 0.0;

    for (final member in _addedFamilyMembers) {
      final occupations = member['occupations'];
      if (occupations is! List) continue;

      for (final occupation in occupations) {
        if (occupation is! Map) continue;
        total += _parseMoneyValue(
          occupation['monthlyIncome'] ?? occupation['headerTitle'],
        );
      }
    }

    if (_recebeValorImovelAlugado == 1) {
      total += _parseMoneyValue(_imovelAlugadoValueController.text);
    }
    if (_ajudaFinanceira == 1) {
      total += _parseMoneyValue(_ajudaFamiliarValueController.text);
    } else if (_ajudaFinanceira == 2) {
      total += _parseMoneyValue(_ajudaOutroValueController.text);
    }
    if (_beneficiarioProgramaGoverno == 1) {
      total += _parseMoneyValue(_programaGovernoValueController.text);
    }

    return total;
  }

  int get _incomeDependents =>
      _addedFamilyMembers.isEmpty ? 1 : _addedFamilyMembers.length;

  double get _perCapitaIncome =>
      _computeGrossFamilyIncome() / _incomeDependents;

  String _formatSalaryRatio(double perCapitaIncome) {
    final ratio = perCapitaIncome / _minimumWage;
    return '${NumberFormat('#,##0.00', 'pt_BR').format(ratio)} '
        '${AppI18n.current.salaryRatioSuffix}';
  }

  Widget _buildSummaryRow(String label, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.bodyLarge,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            value,
            style: AppTextStyles.titleSmall,
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryStep() {
    final i18n = AppI18n.current;
    final grossIncome = _computeGrossFamilyIncome();
    final perCapitaIncome = _perCapitaIncome;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSummaryRow(
          i18n.grossFamilyIncomeLabel,
          _formatCurrency(grossIncome),
        ),
        _buildSummaryRow(
          i18n.incomeDependentsLabel,
          _incomeDependents.toString(),
        ),
        _buildSummaryRow(
          i18n.perCapitaIncomeLabel,
          _formatCurrency(perCapitaIncome),
        ),
        _buildSummaryRow(
          i18n.minimumWageLabel,
          _formatCurrency(_minimumWage),
        ),
        _buildSummaryRow(
          i18n.perCapitaTimesMinimumWageLabel,
          _formatSalaryRatio(perCapitaIncome),
        ),
      ],
    );
  }

  void _resetMemberForm() {
    _vm.cpfController.clear();
    _vm.nameController.clear();
    _vm.dobController.clear();
    _vm.nacionalityController.clear();
    _vm.rgController.clear();
    _vm.orgaoController.clear();
    _vm.nisController.clear();
    _vm.tipoDoencaController.clear();
    _vm.selectedGender = null;
    _vm.maritalStatus = null;
    _vm.selectedResponsible = null;
    _vm.selectedPcd = null;
    _vm.selectedState = null;
    _vm.cadunicoValue = null;
    _vm.recebePensao = null;
    _vm.aposentado = null;
    _vm.seraCandidato = null;
    _vm.naturalizado = null;
    _vm.possuiCIN = null;
    _vm.possuiDoenca = null;
    _vm.irpfCondition = null;
    _vm.declarouEsseAno = null;
    _vm.temCarteira = null;
    _vm.trabalhadorRural = null;
    _vm.superdotacao = null;
    _vm.espectro = null;
    _addedOccupations.clear();
    _hasOccupation = false;
    _recebePensaoAlimenticia = 0;
    _recebePrevidenciaPrivada = 0;
    _recebeOutroBeneficioINSS = 0;
    _showPensionNisField = false;
    _showPrevidenciaValueField = false;
    _showInssValueField = false;
    _pensionValueController.clear();
    _previdenciaValueController.clear();
    _beneficioValueController.clear();
  }

  void _commitCurrentMemberToList() {
    _addedFamilyMembers.add({
      'cpf': _vm.cpfController.text.trim(),
      'name': _vm.nameController.text.trim(),
      'dob': _vm.dobController.text.trim(),
      'maritalStatus': _vm.maritalStatus?.toKey(),
      'isScholarshipCandidate': _vm.seraCandidato == 1,
      'occupations': List<Map<String, dynamic>>.from(_addedOccupations),
    });
    _resetMemberForm();
  }

  Future<void> _onAdvanceFromFamilyMembersStep() async {
    final confirmed = await _showFamilyMembersConfirmDialog();
    if (confirmed == true && mounted) {
      setState(() => _currentSubStep++);
    }
  }

  Future<void> _onBackFromSummaryStep() async {
    final confirmed = await _showSummaryBackDialog();
    if (confirmed == true && mounted) {
      setState(() => _currentSubStep--);
    }
  }

  Future<bool?> _showSummaryBackDialog() {
    final i18n = AppI18n.current;

    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundLight,
        title: Text(
          i18n.familyConfirmDialogTitle,
          style: AppTextStyles.titleLarge,
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                i18n.summaryAdvanceDialogBody1,
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 16),
              Text(
                i18n.summaryAdvanceDialogBody2,
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 16),
              Text(
                i18n.summaryAdvanceDialogQuestion,
                style: AppTextStyles.bodyMedium,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              i18n.answerNo,
              style: AppTextStyles.titleSmall.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              i18n.summaryAdvanceDialogConfirm,
              style: AppTextStyles.titleSmall.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showFamilyMembersConfirmDialog() {
    final i18n = AppI18n.current;
    const underline = TextStyle(decoration: TextDecoration.underline);
    const dialogWidth = 354.0;
    const dialogHeight = 460.0;

    return showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: AppColors.backgroundLight,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        child: SizedBox(
          width: dialogWidth,
          height: dialogHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Text(
                  i18n.familyConfirmDialogTitle,
                  style: AppTextStyles.titleLarge,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          style: AppTextStyles.bodyMedium,
                          children: [
                            TextSpan(
                              text: i18n.familyConfirmDialogBodyEmphasis1,
                              style: underline.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                            TextSpan(text: i18n.familyConfirmDialogBodyMiddle),
                            TextSpan(
                              text: i18n.familyConfirmDialogBodyEmphasis2,
                              style: underline.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                            TextSpan(text: i18n.familyConfirmDialogBodySuffix),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        i18n.familyConfirmDialogMembersIntro,
                        style: AppTextStyles.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      for (final member in _addedFamilyMembers)
                        Padding(
                          padding: const EdgeInsets.only(left: 8, bottom: 4),
                          child: Text(
                            '• ${member['cpf']} - ${member['name']}'
                            '${member['isScholarshipCandidate'] == true ? ' (${i18n.scholarshipCandidateTag})' : ''}',
                            style: AppTextStyles.bodyMedium,
                          ),
                        ),
                      const SizedBox(height: 16),
                      Text(
                        i18n.familyConfirmDialogQuestion,
                        style: AppTextStyles.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(
                        i18n.familyConfirmDialogReview,
                        style: AppTextStyles.titleSmall.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(
                        i18n.familyConfirmDialogContinue,
                        style: AppTextStyles.titleSmall.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFamilyInfo() {
    EbolsaInfoBottomSheet.show(
      context,
      iconData: Icons.info_outline,
      iconColor: AppColors.warning,
      sections: [
        EbolsaInfoSection(
          title: AppI18n.current.familyInfoGroupTitle,
          description: AppI18n.current.familyInfoGroupDescription,
        ),
        EbolsaInfoSection(
          title: AppI18n.current.familyInfoIncomeTitle,
          description: AppI18n.current.familyInfoIncomeDescription,
        ),
        EbolsaInfoSection(
          title: AppI18n.current.familyInfoKinshipTitle,
          description: AppI18n.current.familyInfoKinshipDescription,
        ),
      ],
      closeLabel: AppI18n.current.noticesTermsCloseAction,
    );
  }

  Widget _buildStepHeader() {
    final config = memberRegistrationSubStepConfig(_currentSubStep);

    return EbolsaStepHeader(
      key: ValueKey('member-registration-header-$_currentSubStep'),
      title: config.headerTitle,
      description: config.headerDescription,
      descriptionWidget: config.headerDescriptionWidget,
      trailing: config.showFamilyInfoIcon
          ? GestureDetector(
              onTap: _showFamilyInfo,
              child: const Icon(
                Icons.info_outline,
                color: AppColors.warning,
                size: 24,
              ),
            )
          : null,
    );
  }

  Widget _buildSubStepNavArrow({
    required IconData icon,
    required bool isEnabled,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isEnabled ? AppColors.primary : AppColors.surface,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isEnabled ? Colors.white : AppColors.outline,
        ),
      ),
    );
  }

  Widget _buildStepFooter() {
    if (_currentSubStep >= 3) {
      final hasNextSubStep = _currentSubStep < _totalSubSteps;

      return Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  if (_currentSubStep == 6) {
                    _onBackFromSummaryStep();
                    return;
                  }
                  setState(() => _currentSubStep--);
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  side: const BorderSide(color: Color(0xFFB9BDC6)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: Text(
                  'Voltar',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.onSurface,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: EbolsaButton(
                onPressed: hasNextSubStep
                    ? () {
                        if (_currentSubStep == 3) {
                          _onAdvanceFromFamilyMembersStep();
                          return;
                        }
                        setState(() => _currentSubStep++);
                      }
                    : () => Navigator.of(context).pop(kAdvanceToExpensesResult),
                label: hasNextSubStep
                    ? AppI18n.current.createAccountNextAction
                    : AppI18n.current.createAccountNextAction,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: EbolsaButton(
        onPressed: (_currentSubStep == 2 && !_hasOccupation)
            ? null
            : () {
                if (_currentSubStep == 2) {
                  _commitCurrentMemberToList();
                  setState(() => _currentSubStep++);
                  return;
                }
                if (_currentSubStep < _totalSubSteps) {
                  setState(() => _currentSubStep++);
                  return;
                }
                Navigator.of(context).pop();
              },
        label: _currentSubStep == 2
            ? 'Salvar membro familiar'
            : AppI18n.current.createAccountNextAction,
      ),
    );
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
              child: ScholarshipStepIndicator(
                currentStep: 2,
                completedStep: 2,
                onStepTap: (step) {},
              ),
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
                      _buildStepHeader(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: Row(
                          children: [
                            _buildSubStepNavArrow(
                              icon: Icons.arrow_back,
                              isEnabled: _currentSubStep > 1,
                              onTap: () {
                                if (_currentSubStep == 6) {
                                  _onBackFromSummaryStep();
                                  return;
                                }
                                setState(() => _currentSubStep--);
                              },
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Center(
                                child: Text(
                                  memberRegistrationSubStepConfig(
                                    _currentSubStep,
                                  ).navTitle,
                                  style: AppTextStyles.titleLarge,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            _buildSubStepNavArrow(
                              icon: Icons.arrow_forward,
                              isEnabled: _currentSubStep < _totalSubSteps,
                              onTap: () {
                                if (_currentSubStep == 3) {
                                  _onAdvanceFromFamilyMembersStep();
                                  return;
                                }
                                setState(() => _currentSubStep++);
                              },
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
                          EbolsaRadioGroup<int>(
                            question: AppI18n.current.receivesPensionQuestion,
                            options: [
                              RadioOption(
                                  label: AppI18n.current.answerNo, value: 0),
                              RadioOption(
                                  label: AppI18n.current.answerYes, value: 1),
                            ],
                            groupValue: _vm.recebePensao,
                            onChanged: (v) => _vm.setRecebePensao(v),
                          ),
                          // se ele responder que sim, deve mostrar o campo para inserir se é aposentado(a)?
                          if (_vm.showIsRetired) ...[
                            const SizedBox(height: 16),
                            EbolsaRadioGroup<int>(
                              question: AppI18n.current.isRetiredQuestion,
                              options: [
                                RadioOption(
                                    label: AppI18n.current.answerNo, value: 0),
                                RadioOption(
                                    label: AppI18n.current.answerYes, value: 1),
                              ],
                              groupValue: _vm.aposentado,
                              onChanged: (v) => _vm.setAposentado(v),
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
                          groupValue: _vm.seraCandidato,
                          onChanged: (v) => _vm.setSeraCandidato(v),
                        ),
                        //Se ele responder sim, mostrar o campo para selecionar a nacionalidade
                        if (_vm.seraCandidato == 1) ...[
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 56,
                            child: InkWell(
                              onTap: _openNationalitySelector,
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
                                  _vm.nacionalityController.text.isNotEmpty
                                      ? _vm.nacionalityController.text
                                      : AppI18n.current.nationalityLabel,
                                  style: _vm.nacionalityController.text.isEmpty
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
                        if ((_vm.nacionalityController.text
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
                            groupValue: _vm.naturalizado,
                            onChanged: (v) => _vm.setNaturalizado(v),
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
                        EbolsaRadioGroup<int>(
                          question: AppI18n.current.hasCINQuestion,
                          options: [
                            RadioOption(
                                label: AppI18n.current.answerNo, value: 0),
                            RadioOption(
                                label: AppI18n.current.answerYes, value: 1),
                          ],
                          groupValue: _vm.possuiCIN,
                          onChanged: (v) => setState(() => _vm.possuiCIN = v),
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
                        EbolsaRadioGroup<int>(
                          question: AppI18n.current.hasCadunicoQuestion,
                          options: [
                            RadioOption(
                                label: AppI18n.current.answerNo, value: 0),
                            RadioOption(
                                label: AppI18n.current.answerYes, value: 1),
                          ],
                          groupValue: _vm.cadunicoValue,
                          onChanged: (v) =>
                              setState(() => _vm.cadunicoValue = v),
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
                        EbolsaRadioGroup<int>(
                          question: 'Transtorno do Espectro Autista(TEA)?',
                          options: [
                            RadioOption(
                                label: AppI18n.current.answerNo, value: 0),
                            RadioOption(
                                label: AppI18n.current.answerYes, value: 1),
                          ],
                          groupValue: _vm.espectro,
                          onChanged: (v) => setState(() => _vm.espectro = v),
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
                          groupValue: _vm.superdotacao,
                          onChanged: (v) =>
                              setState(() => _vm.superdotacao = v),
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
                          groupValue: _vm.possuiDoenca,
                          onChanged: (v) =>
                              setState(() => _vm.possuiDoenca = v),
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
                            onTap: _openPcdSelector,
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
                                _vm.selectedPcd ?? 'Selecione',
                                style: _vm.selectedPcd == null
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
                          groupValue: _vm.irpfCondition,
                          onChanged: (v) =>
                              setState(() => _vm.irpfCondition = v),
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
                          groupValue: _vm.declarouEsseAno,
                          onChanged: (v) =>
                              setState(() => _vm.declarouEsseAno = v),
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
                          groupValue: _vm.temCarteira,
                          onChanged: (v) => setState(() => _vm.temCarteira = v),
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
                          groupValue: _vm.trabalhadorRural,
                          onChanged: (v) =>
                              setState(() => _vm.trabalhadorRural = v),
                        ),
                      ] else if (_currentSubStep == 2) ...[
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              color: AppColors.surfaceContainer,
                              size: 24,
                            ),
                            SizedBox(width: 12),
                            Text(
                              AppI18n.current.dataComplementTitle,
                              style: AppTextStyles.ebolsaTitleMedium,
                            ),
                          ],
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 12.0, bottom: 22.0),
                          child: Text(
                            AppI18n.current.complementFieldsPlaceholder,
                            style: AppTextStyles.bodySmall,
                          ),
                        ),
                        EbolsaButton(
                          height: 48,
                          borderRadius: 8,
                          backgroundColor: AppColors.secondaryContainer,
                          onPressed: () async {
                            final res = await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => OccupationPage(
                                  initialPension: _recebePensaoAlimenticia,
                                  initialPrevidencia: _recebePrevidenciaPrivada,
                                  initialInss: _recebeOutroBeneficioINSS,
                                ),
                              ),
                            );
                            if (res != null && res is Map) {
                              setState(() {
                                final p = res['pension'];
                                if (p is int) {
                                  _recebePensaoAlimenticia = p;
                                } else if (p is String) {
                                  _recebePensaoAlimenticia = int.tryParse(p) ??
                                      _recebePensaoAlimenticia;
                                }

                                final previd = res['previdencia'];
                                if (previd is int) {
                                  _recebePrevidenciaPrivada = previd;
                                } else if (previd is String) {
                                  _recebePrevidenciaPrivada =
                                      int.tryParse(previd) ??
                                          _recebePrevidenciaPrivada;
                                }

                                final inss = res['inss'];
                                if (inss is int) {
                                  _recebeOutroBeneficioINSS = inss;
                                } else if (inss is String) {
                                  _recebeOutroBeneficioINSS =
                                      int.tryParse(inss) ??
                                          _recebeOutroBeneficioINSS;
                                }

                                final occupation = res['occupation'];
                                if (occupation is String) {
                                  if (occupation != 'Nenhum') {
                                    _addedOccupations
                                        .add(Map<String, dynamic>.from(res));
                                  }
                                  _hasOccupation = _addedOccupations.isNotEmpty;
                                }
                              });
                            }
                          },
                          label: '+ Adicionar ocupação',
                          textStyle: AppTextStyles.ebolsaTitleMedium.copyWith(
                            color: AppColors.onPrimaryContainer,
                          ),
                        ),
                        if (_addedOccupations.isNotEmpty) ...[
                          for (var i = 0;
                              i < _addedOccupations.length;
                              i++) ...[
                            EbolsaMemberCard(
                              headerTitle: _formatCurrency(_addedOccupations[i]
                                      ['monthlyIncome'] ??
                                  _addedOccupations[i]['headerTitle']),
                              title: _addedOccupations[i]['occupation'] ?? '',
                              subtitle: _addedOccupations[i]
                                          ['occupationDetails'] !=
                                      null
                                  ? (_addedOccupations[i]['occupationDetails']
                                          ['function'] ??
                                      '')
                                  : (_addedOccupations[i]['subtitle'] ?? ''),
                              content: _addedOccupations[i]['company'] != null
                                  ? [
                                      Text(_addedOccupations[i]['company']
                                          .toString())
                                    ]
                                  : const [],
                              onEdit: () async {
                                final res = await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => OccupationPage(
                                      initialPension: _recebePensaoAlimenticia,
                                      initialPrevidencia:
                                          _recebePrevidenciaPrivada,
                                      initialInss: _recebeOutroBeneficioINSS,
                                      initialOccupation: _addedOccupations[i]
                                          ['occupation'] as String?,
                                      initialOccupationDetails:
                                          _addedOccupations[i]
                                                      ['occupationDetails'] !=
                                                  null
                                              ? Map<String, String>.from(
                                                  _addedOccupations[i]
                                                      ['occupationDetails'])
                                              : null,
                                      initialMonthlyIncome: _addedOccupations[i]
                                                  ['monthlyIncome'] !=
                                              null
                                          ? _addedOccupations[i]
                                                  ['monthlyIncome']
                                              .toString()
                                          : (_addedOccupations[i]['headerTitle']
                                              ?.toString()),
                                    ),
                                  ),
                                );
                                if (res != null && res is Map) {
                                  setState(() {
                                    _addedOccupations[i] =
                                        Map<String, dynamic>.from(res);
                                    _hasOccupation =
                                        _addedOccupations.isNotEmpty;
                                  });
                                }
                              },
                              onDelete: () async {
                                final confirmed = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    backgroundColor: AppColors.backgroundLight,
                                    title: Text('Confirmação',
                                        style: AppTextStyles.titleLarge),
                                    content: Text(
                                      'Tem certeza que deseja excluir "${_addedOccupations[i]['occupation'] ?? 'tipo da ocupação'}" como ocupação?',
                                      style: AppTextStyles.bodyMedium,
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child: Text('Não',
                                            style: AppTextStyles.bodyMedium),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                        child: Text('Sim',
                                            style: AppTextStyles.bodyMedium
                                                .copyWith(
                                                    color: AppColors.primary)),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirmed == true) {
                                  setState(() {
                                    _addedOccupations.removeAt(i);
                                    _hasOccupation =
                                        _addedOccupations.isNotEmpty;
                                  });
                                }
                              },
                            ),
                          ],
                        ],
                        const SizedBox(height: 16),
                      ] else if (_currentSubStep == 3) ...[
                        EbolsaButton(
                          height: 48,
                          borderRadius: 8,
                          backgroundColor: AppColors.secondaryContainer,
                          onPressed: () {
                            _resetMemberForm();
                            setState(() => _currentSubStep = 1);
                          },
                          label: '+ Adicionar membro familiar',
                          textStyle: AppTextStyles.ebolsaTitleMedium.copyWith(
                            color: AppColors.onPrimaryContainer,
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (_addedFamilyMembers.isEmpty) ...[
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24),
                              child: Text('Nenhum membro registrado ainda.',
                                  style: AppTextStyles.bodyMedium),
                            ),
                          ),
                        ] else ...[
                          for (var i = 0;
                              i < _addedFamilyMembers.length;
                              i++) ...[
                            EbolsaMemberCard(
                              headerTitle: _addedFamilyMembers[i]['cpf'] ?? '',
                              tag: _addedFamilyMembers[i]
                                          ['isScholarshipCandidate'] ==
                                      true
                                  ? AppI18n.current.scholarshipCandidateTag
                                  : null,
                              title: _addedFamilyMembers[i]['name'] ?? '',
                              subtitle: _addedFamilyMembers[i]['maritalStatus']
                                  ?.toString(),
                              content: const [],
                              onEdit: () {
                                setState(() => _currentSubStep = 1);
                              },
                              onDelete: () {
                                setState(() {
                                  _addedFamilyMembers.removeAt(i);
                                });
                              },
                            ),
                            const SizedBox(height: 12),
                          ],
                        ],
                        const SizedBox(height: 200),
                      ] else if (_currentSubStep == 4) ...[
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
                          groupValue: _recebeValorImovelAlugado,
                          onChanged: _onRecebeValorImovelAlugadoChanged,
                        ),
                        if (_recebeValorImovelAlugado == 1) ...[
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 56,
                            child: EbolsaTextField(
                              controller: _imovelAlugadoValueController,
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
                          groupValue: _ajudaFinanceira,
                          onChanged: _onAjudaFinanceiraChanged,
                        ),
                        if (_ajudaFinanceira == 1) ...[
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 56,
                            child: EbolsaTextField(
                              controller: _ajudaFamiliarValueController,
                              label: AppI18n.current.informValueInReaisLabel,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                            ),
                          ),
                        ],
                        if (_ajudaFinanceira == 2) ...[
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 56,
                            child: EbolsaTextField(
                              controller: _ajudaOutroDeQuemController,
                              label: AppI18n.current.financialHelpFromWhomLabel,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 56,
                            child: EbolsaTextField(
                              controller: _ajudaOutroValueController,
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
                          groupValue: _beneficiarioProgramaGoverno,
                          onChanged: _onBeneficiarioProgramaGovernoChanged,
                        ),
                        if (_beneficiarioProgramaGoverno == 1) ...[
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 56,
                            child: EbolsaTextField(
                              controller: _programaGovernoController,
                              label:
                                  AppI18n.current.informGovernmentProgramLabel,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 56,
                            child: EbolsaTextField(
                              controller: _programaGovernoValueController,
                              label: AppI18n.current.informValueInReaisLabel,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                            ),
                          ),
                        ],
                      ] else if (_currentSubStep == 5) ...[
                        EbolsaRadioGroup<int>(
                          question: AppI18n.current.ownsPropertyQuestion,
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
                          groupValue: _possuiImovelProprio,
                          onChanged: _onPossuiImovelProprioChanged,
                        ),
                        if (_possuiImovelProprio == 1) ...[
                          const SizedBox(height: 16),
                          EbolsaButton(
                            height: 48,
                            borderRadius: 8,
                            backgroundColor: AppColors.secondaryContainer,
                            onPressed: _openOwnPropertyForm,
                            label: AppI18n.current.addPropertyAction,
                            textStyle: AppTextStyles.ebolsaTitleMedium.copyWith(
                              color: AppColors.onPrimaryContainer,
                            ),
                          ),
                          if (_addedProperties.isNotEmpty) ...[
                            for (var i = 0;
                                i < _addedProperties.length;
                                i++) ...[
                              EbolsaMemberCard(
                                title:
                                    _addedProperties[i]['type']?.toString() ??
                                        '',
                                content: [
                                  Text(
                                    '${AppI18n.current.propertyFinancingValueLabel} '
                                    '${_formatCurrency(_addedProperties[i]['installmentValue'])}',
                                    style: AppTextStyles.bodyMedium,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${AppI18n.current.propertyAssetValueDisplayLabel} '
                                    '${_formatCurrency(_addedProperties[i]['assetValue'])}',
                                    style: AppTextStyles.bodyMedium,
                                  ),
                                ],
                                onEdit: () =>
                                    _openOwnPropertyForm(editIndex: i),
                                onDelete: () {
                                  setState(() => _addedProperties.removeAt(i));
                                },
                              ),
                            ],
                          ],
                        ],
                        const SizedBox(height: 16),
                        EbolsaRadioGroup<int>(
                          question:
                              AppI18n.current.ownsFinancialInvestmentQuestion,
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
                          groupValue: _possuiInvestimentoFinanceiro,
                          onChanged: _onPossuiInvestimentoFinanceiroChanged,
                        ),
                        if (_possuiInvestimentoFinanceiro == 1) ...[
                          const SizedBox(height: 16),
                          EbolsaButton(
                            height: 48,
                            borderRadius: 8,
                            backgroundColor: AppColors.secondaryContainer,
                            onPressed: _openFinancialInvestmentForm,
                            label: AppI18n.current.addInvestmentAction,
                            textStyle: AppTextStyles.ebolsaTitleMedium.copyWith(
                              color: AppColors.onPrimaryContainer,
                            ),
                          ),
                          if (_addedInvestments.isNotEmpty) ...[
                            for (var i = 0;
                                i < _addedInvestments.length;
                                i++) ...[
                              EbolsaMemberCard(
                                title:
                                    _addedInvestments[i]['type']?.toString() ??
                                        '',
                                content: [
                                  Text(
                                    '${AppI18n.current.valueDisplayLabel} '
                                    '${_formatCurrency(_addedInvestments[i]['value'])}',
                                    style: AppTextStyles.bodyMedium,
                                  ),
                                ],
                                onEdit: () =>
                                    _openFinancialInvestmentForm(editIndex: i),
                                onDelete: () {
                                  setState(
                                    () => _addedInvestments.removeAt(i),
                                  );
                                },
                              ),
                            ],
                          ],
                        ],
                        const SizedBox(height: 16),
                        EbolsaRadioGroup<int>(
                          question: AppI18n.current.ownsVehicleQuestion,
                          subtitle: AppI18n.current.ownsVehicleSubtitle,
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
                          groupValue: _possuiVeiculo,
                          onChanged: _onPossuiVeiculoChanged,
                        ),
                        if (_possuiVeiculo == 1) ...[
                          const SizedBox(height: 16),
                          EbolsaButton(
                            height: 48,
                            borderRadius: 8,
                            backgroundColor: AppColors.secondaryContainer,
                            onPressed: _openVehicleForm,
                            label: AppI18n.current.addVehicleAction,
                            textStyle: AppTextStyles.ebolsaTitleMedium.copyWith(
                              color: AppColors.onPrimaryContainer,
                            ),
                          ),
                          if (_addedVehicles.isNotEmpty) ...[
                            for (var i = 0; i < _addedVehicles.length; i++) ...[
                              EbolsaMemberCard(
                                title:
                                    '${_addedVehicles[i]['brand']} ${_addedVehicles[i]['model']}',
                                content: [
                                  Text(
                                    '${AppI18n.current.vehicleYearDisplayLabel} '
                                    '${_addedVehicles[i]['year']}',
                                    style: AppTextStyles.bodyMedium,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${AppI18n.current.vehicleInstallmentDisplayLabel} '
                                    '${_formatCurrency(_addedVehicles[i]['installmentValue'])}',
                                    style: AppTextStyles.bodyMedium,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${AppI18n.current.propertyAssetValueDisplayLabel} '
                                    '${_formatCurrency(_addedVehicles[i]['assetValue'])}',
                                    style: AppTextStyles.bodyMedium,
                                  ),
                                ],
                                onEdit: () => _openVehicleForm(editIndex: i),
                                onDelete: () {
                                  setState(() => _addedVehicles.removeAt(i));
                                },
                              ),
                            ],
                          ],
                        ],
                      ] else if (_currentSubStep == 6) ...[
                        _buildSummaryStep(),
                      ],
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
            _buildStepFooter(),
          ],
        ),
      ),
    );
  }
}
