import 'package:flutter/material.dart';

import '../../../../../main/i18n/app_i18n.dart';
import '../../../../components/components.dart';
import '../../../../helpers/themes/themes.dart';

class EducationExpensePage extends StatefulWidget {
  const EducationExpensePage({
    super.key,
    required this.familyMemberNames,
    this.initialType,
    this.initialMemberName,
    this.initialInstitution,
    this.initialMonthlyValue,
  });

  final List<String> familyMemberNames;
  final String? initialType;
  final String? initialMemberName;
  final String? initialInstitution;
  final String? initialMonthlyValue;

  @override
  State<EducationExpensePage> createState() => _EducationExpensePageState();
}

class _EducationExpensePageState extends State<EducationExpensePage> {
  String? _selectedType;
  String? _selectedMemberName;
  late final TextEditingController _memberNameController;
  late final TextEditingController _institutionController;
  late final TextEditingController _monthlyValueController;

  bool get _usesMemberSelector => widget.familyMemberNames.isNotEmpty;

  List<String> get _typeOptions {
    final i18n = AppI18n.current;
    return [
      i18n.expenseEducationTypeBasic,
      i18n.expenseEducationTypeHigher,
      i18n.expenseEducationTypeLanguage,
      i18n.expenseEducationTypeOther,
    ];
  }

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialType;
    _selectedMemberName = widget.initialMemberName;
    _memberNameController = TextEditingController(
      text: widget.initialMemberName ?? '',
    );
    _institutionController = TextEditingController(
      text: widget.initialInstitution ?? '',
    );
    _monthlyValueController = TextEditingController(
      text: widget.initialMonthlyValue ?? '',
    );
  }

  @override
  void dispose() {
    _memberNameController.dispose();
    _institutionController.dispose();
    _monthlyValueController.dispose();
    super.dispose();
  }

  bool get _canSave {
    final memberName = _usesMemberSelector
        ? _selectedMemberName
        : _memberNameController.text.trim();
    return _selectedType != null &&
        memberName != null &&
        memberName.isNotEmpty &&
        _institutionController.text.trim().isNotEmpty &&
        _monthlyValueController.text.trim().isNotEmpty;
  }

  Future<void> _openTypeSelector() async {
    final i18n = AppI18n.current;
    final selected = await SearchableOptionsBottomSheet.show<String>(
      context: context,
      title: i18n.typeLabel,
      options: _typeOptions,
      searchHint: i18n.noticesTermsSearchHint,
      helperText: i18n.noticesTermsBottomSheetSearchHelp,
      emptyStateText: i18n.noticesTermsBottomSheetNoResults,
      closeTooltip: i18n.noticesTermsCloseAction,
      selectedValue: _selectedType,
    );
    if (selected != null) {
      setState(() => _selectedType = selected);
    }
  }

  Future<void> _openMemberSelector() async {
    final i18n = AppI18n.current;
    final selected = await SearchableOptionsBottomSheet.show<String>(
      context: context,
      title: i18n.expenseEducationForWhomLabel,
      options: widget.familyMemberNames,
      searchHint: i18n.noticesTermsSearchHint,
      helperText: i18n.noticesTermsBottomSheetSearchHelp,
      emptyStateText: i18n.noticesTermsBottomSheetNoResults,
      closeTooltip: i18n.noticesTermsCloseAction,
      selectedValue: _selectedMemberName,
    );
    if (selected != null) {
      setState(() => _selectedMemberName = selected);
    }
  }

  void _saveAndReturn() {
    if (!_canSave) return;

    final memberName = _usesMemberSelector
        ? _selectedMemberName!
        : _memberNameController.text.trim();

    Navigator.of(context).pop({
      'type': _selectedType,
      'memberName': memberName,
      'institution': _institutionController.text.trim(),
      'monthlyValue': _monthlyValueController.text.trim(),
    });
  }

  Widget _buildSelectorField({
    required String hint,
    required String? value,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 56,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: InputDecorator(
          decoration: InputDecoration(
            hintText: hint,
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
            value ?? hint,
            style: value == null
                ? AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.onSurface.withValues(alpha: 0.6),
                  )
                : AppTextStyles.bodyMedium,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final i18n = AppI18n.current;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(i18n.expensesStepTitle),
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
              i18n.expensesEducationSubStepNavTitle,
              style: AppTextStyles.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              i18n.educationExpensePageDescription,
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 24),
            _buildSelectorField(
              hint: i18n.typeLabel,
              value: _selectedType,
              onTap: _openTypeSelector,
            ),
            const SizedBox(height: 12),
            if (_usesMemberSelector)
              _buildSelectorField(
                hint: i18n.expenseEducationForWhomLabel,
                value: _selectedMemberName,
                onTap: _openMemberSelector,
              )
            else
              SizedBox(
                height: 56,
                child: EbolsaTextField(
                  controller: _memberNameController,
                  label: i18n.expenseEducationForWhomLabel,
                  onChanged: (_) => setState(() {}),
                ),
              ),
            const SizedBox(height: 12),
            SizedBox(
              height: 56,
              child: EbolsaTextField(
                controller: _institutionController,
                label: i18n.expenseEducationInstitutionLabel,
                onChanged: (_) => setState(() {}),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 56,
              child: EbolsaTextField(
                controller: _monthlyValueController,
                label: i18n.expenseEducationMonthlyValueLabel,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
          ],
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
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            child: Text(
              i18n.saveEducationExpenseAction,
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
