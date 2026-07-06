import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../main/i18n/app_i18n.dart';
import '../../../../components/ebolsa_button.dart';
import '../../../../components/ebolsa_member_card.dart';
import '../../../../components/ebolsa_radio_group.dart';
import '../../../../components/ebolsa_text_field.dart';
import '../../../../helpers/themes/themes.dart';
import 'education_expense_page.dart';

enum SchoolTransportType {
  naoUtiliza,
  pagoFretado,
  proprioCombustivel,
  publico,
}

class ExpensesEducationSubStep extends StatefulWidget {
  const ExpensesEducationSubStep({
    super.key,
    required this.educationValueController,
    this.familyMemberNames = const [],
    this.onFormChanged,
  });

  final TextEditingController educationValueController;
  final List<String> familyMemberNames;
  final VoidCallback? onFormChanged;

  @override
  State<ExpensesEducationSubStep> createState() =>
      ExpensesEducationSubStepState();
}

class ExpensesEducationSubStepState extends State<ExpensesEducationSubStep> {
  int? _hasEducationCosts;
  SchoolTransportType? _schoolTransportType;
  final List<Map<String, dynamic>> _addedEducationExpenses = [];
  String? _hasEducationCostsError;
  String? _schoolTransportError;

  void _notifyFormChanged() => widget.onFormChanged?.call();

  bool get canAdvance {
    if (_hasEducationCosts == null || _schoolTransportType == null) {
      return false;
    }
    if (_hasEducationCosts == 1 && _addedEducationExpenses.isEmpty) {
      return false;
    }
    return widget.educationValueController.text.trim().isNotEmpty;
  }

  bool validate() {
    final i18n = AppI18n.current;
    final hasEducationCostsError = _hasEducationCosts == null
        ? i18n.expenseEducationCostsRequiredError
        : null;
    final schoolTransportError = _schoolTransportType == null
        ? i18n.expenseSchoolTransportRequiredError
        : null;

    setState(() {
      _hasEducationCostsError = hasEducationCostsError;
      _schoolTransportError = schoolTransportError;
    });

    return hasEducationCostsError == null && schoolTransportError == null;
  }

  void _onHasEducationCostsChanged(int? value) {
    setState(() {
      _hasEducationCosts = value;
      _hasEducationCostsError = null;
      if (value != 1) {
        _addedEducationExpenses.clear();
      }
    });
    _notifyFormChanged();
  }

  void _onSchoolTransportChanged(SchoolTransportType? value) {
    setState(() {
      _schoolTransportType = value;
      _schoolTransportError = null;
    });
    _notifyFormChanged();
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
        final normalized = cleaned.replaceAll('.', '').replaceAll(',', '.');
        final parsed = double.tryParse(normalized);
        if (parsed != null) {
          return NumberFormat.simpleCurrency(locale: 'pt_BR', decimalDigits: 2)
              .format(parsed);
        }
      }
      return value.toString();
    } catch (_) {
      return value?.toString() ?? '';
    }
  }

  Future<void> _openEducationExpenseForm({int? editIndex}) async {
    Map<String, dynamic>? initial;
    if (editIndex != null) {
      initial = _addedEducationExpenses[editIndex];
    }

    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(
        builder: (_) => EducationExpensePage(
          familyMemberNames: widget.familyMemberNames,
          initialType: initial?['type'] as String?,
          initialMemberName: initial?['memberName'] as String?,
          initialInstitution: initial?['institution'] as String?,
          initialMonthlyValue: initial?['monthlyValue'] as String?,
        ),
      ),
    );

    if (result == null || !mounted) return;

    setState(() {
      if (editIndex != null) {
        _addedEducationExpenses[editIndex] = result;
      } else {
        _addedEducationExpenses.add(result);
      }
    });
    _notifyFormChanged();
  }

  @override
  Widget build(BuildContext context) {
    final i18n = AppI18n.current;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        EbolsaRadioGroup<int>(
          question: i18n.expenseHasEducationCostsQuestion,
          errorText: _hasEducationCostsError,
          options: [
            RadioOption(label: i18n.answerNo, value: 0),
            RadioOption(label: i18n.answerYes, value: 1),
          ],
          groupValue: _hasEducationCosts,
          onChanged: _onHasEducationCostsChanged,
        ),
        if (_hasEducationCosts == 1) ...[
          const SizedBox(height: 16),
          EbolsaButton(
            height: 48,
            borderRadius: 8,
            backgroundColor: AppColors.secondaryContainer,
            onPressed: _openEducationExpenseForm,
            label: i18n.addEducationExpenseAction,
            textStyle: AppTextStyles.ebolsaTitleMedium.copyWith(
              color: AppColors.onPrimaryContainer,
            ),
          ),
          if (_addedEducationExpenses.isNotEmpty) ...[
            for (var i = 0; i < _addedEducationExpenses.length; i++) ...[
              EbolsaMemberCard(
                title: _addedEducationExpenses[i]['type']?.toString() ?? '',
                content: [
                  Text(
                    '${i18n.expenseEducationForWhomDisplayLabel} '
                    '${_addedEducationExpenses[i]['memberName']}',
                    style: AppTextStyles.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${i18n.expenseEducationWhereDisplayLabel} '
                    '${_addedEducationExpenses[i]['institution']}',
                    style: AppTextStyles.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${i18n.valueDisplayLabel} '
                    '${_formatCurrency(_addedEducationExpenses[i]['monthlyValue'])}',
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
                onEdit: () => _openEducationExpenseForm(editIndex: i),
                onDelete: () {
                  setState(() => _addedEducationExpenses.removeAt(i));
                },
              ),
            ],
          ],
        ],
        const SizedBox(height: 24),
        Text(
          i18n.expenseSchoolTransportQuestion,
          style: AppTextStyles.bodyMedium,
        ),
        if (_schoolTransportError != null) ...[
          const SizedBox(height: 4),
          Text(
            _schoolTransportError!,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
          ),
        ],
        const SizedBox(height: 8),
        _buildSchoolTransportGrid(i18n),
        const SizedBox(height: 12),
        SizedBox(
          height: 56,
          child: EbolsaTextField(
            controller: widget.educationValueController,
            label: i18n.expenseEducationValueLabel,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
        ),
      ],
    );
  }

  Widget _buildSchoolTransportGrid(AppI18n i18n) {
    final options = [
      RadioOption(
        label: i18n.expenseSchoolTransportNaoUtiliza,
        value: SchoolTransportType.naoUtiliza,
      ),
      RadioOption(
        label: i18n.expenseSchoolTransportPagoFretado,
        value: SchoolTransportType.pagoFretado,
      ),
      RadioOption(
        label: i18n.expenseSchoolTransportProprioCombustivel,
        value: SchoolTransportType.proprioCombustivel,
      ),
      RadioOption(
        label: i18n.expenseSchoolTransportPublico,
        value: SchoolTransportType.publico,
      ),
    ];

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildTransportOption(options[0])),
            Expanded(child: _buildTransportOption(options[1])),
          ],
        ),
        Row(
          children: [
            Expanded(child: _buildTransportOption(options[2])),
            Expanded(child: _buildTransportOption(options[3])),
          ],
        ),
      ],
    );
  }

  Widget _buildTransportOption(RadioOption<SchoolTransportType> option) {
    return Row(
      children: [
        Radio<SchoolTransportType>(
          value: option.value,
          groupValue: _schoolTransportType,
          onChanged: _onSchoolTransportChanged,
        ),
        Expanded(
          child: Text(option.label, style: AppTextStyles.bodyMedium),
        ),
      ],
    );
  }
}
