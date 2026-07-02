import 'package:flutter/material.dart';

import '../../../../../main/i18n/app_i18n.dart';
import '../../../../components/ebolsa_text_field.dart';
import '../../../../helpers/themes/themes.dart';

class ExpensesHealthSubStep extends StatefulWidget {
  const ExpensesHealthSubStep({
    super.key,
    required this.healthPlanController,
    required this.chronicDiseaseController,
    required this.otherServicesController,
    required this.otherServicesSpecifyController,
  });

  final TextEditingController healthPlanController;
  final TextEditingController chronicDiseaseController;
  final TextEditingController otherServicesController;
  final TextEditingController otherServicesSpecifyController;

  @override
  State<ExpensesHealthSubStep> createState() => _ExpensesHealthSubStepState();
}

class _ExpensesHealthSubStepState extends State<ExpensesHealthSubStep> {
  bool _chronicDiseaseAcknowledged = false;
  bool _showOtherServicesSpecifyField = false;

  @override
  void initState() {
    super.initState();
    _showOtherServicesSpecifyField =
        widget.otherServicesController.text.trim().isNotEmpty;
    widget.otherServicesController.addListener(_onOtherServicesChanged);
  }

  @override
  void dispose() {
    widget.otherServicesController.removeListener(_onOtherServicesChanged);
    super.dispose();
  }

  void _onOtherServicesChanged() {
    final hasValue = widget.otherServicesController.text.trim().isNotEmpty;
    if (hasValue == _showOtherServicesSpecifyField) return;

    setState(() {
      _showOtherServicesSpecifyField = hasValue;
      if (!hasValue) {
        widget.otherServicesSpecifyController.clear();
      }
    });
  }

  Future<void> _showChronicDiseaseDialog() {
    final i18n = AppI18n.current;

    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          i18n.familyConfirmDialogTitle,
          style: AppTextStyles.titleLarge,
        ),
        content: Text(
          i18n.expenseChronicDiseaseDialogBody,
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() => _chronicDiseaseAcknowledged = true);
              Navigator.of(context).pop();
            },
            child: Text(
              i18n.createAccountDialogDoneButton,
              style: AppTextStyles.titleSmall.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onChronicDiseaseFieldTap() async {
    if (_chronicDiseaseAcknowledged) return;
    await _showChronicDiseaseDialog();
  }

  @override
  Widget build(BuildContext context) {
    final i18n = AppI18n.current;
    const keyboard = TextInputType.numberWithOptions(decimal: true);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildField(
          widget.healthPlanController,
          i18n.expenseHealthPlanValueLabel,
          keyboard,
          helperText: i18n.expenseHealthPlanHelper,
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: _onChronicDiseaseFieldTap,
          behavior: HitTestBehavior.opaque,
          child: AbsorbPointer(
            absorbing: !_chronicDiseaseAcknowledged,
            child: _buildField(
              widget.chronicDiseaseController,
              i18n.expenseChronicDiseaseValueLabel,
              keyboard,
              helperText: i18n.expenseChronicDiseaseHelper,
            ),
          ),
        ),
        const SizedBox(height: 12),
        _buildField(
          widget.otherServicesController,
          i18n.expenseOtherHealthServicesValueLabel,
          keyboard,
        ),
        if (_showOtherServicesSpecifyField) ...[
          const SizedBox(height: 12),
          _buildField(
            widget.otherServicesSpecifyController,
            i18n.expenseOtherHealthServicesSpecifyLabel,
            TextInputType.text,
          ),
        ],
      ],
    );
  }

  Widget _buildField(
    TextEditingController controller,
    String label,
    TextInputType keyboardType, {
    String? helperText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 56,
          child: EbolsaTextField(
            controller: controller,
            label: label,
            keyboardType: keyboardType,
          ),
        ),
        if (helperText != null) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              helperText,
              style: AppTextStyles.bodySmall,
            ),
          ),
        ],
      ],
    );
  }
}
