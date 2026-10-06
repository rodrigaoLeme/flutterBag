import 'package:flutter/material.dart';

import '../../../../../main/i18n/app_i18n.dart';
import '../../../../components/ebolsa_text_field.dart';
import '../../../../helpers/money_text_input_formatter.dart';
import '../../../../helpers/themes/themes.dart';

class ExpensesLoansSubStep extends StatefulWidget {
  const ExpensesLoansSubStep({
    super.key,
    required this.bankLoansController,
    required this.otherServicesController,
    required this.otherServicesDescribeController,
    this.onFormChanged,
  });

  final TextEditingController bankLoansController;
  final TextEditingController otherServicesController;
  final TextEditingController otherServicesDescribeController;
  final VoidCallback? onFormChanged;

  @override
  State<ExpensesLoansSubStep> createState() => ExpensesLoansSubStepState();
}

class ExpensesLoansSubStepState extends State<ExpensesLoansSubStep> {
  bool _showOtherServicesDescribeField = false;

  bool get isComplete {
    final bankLoansFilled = widget.bankLoansController.text.trim().isNotEmpty;
    final otherServicesFilled =
        widget.otherServicesController.text.trim().isNotEmpty;
    final describeFilled = !_showOtherServicesDescribeField ||
        widget.otherServicesDescribeController.text.trim().isNotEmpty;

    return bankLoansFilled && otherServicesFilled && describeFilled;
  }

  void _notifyFormChanged() => widget.onFormChanged?.call();

  bool get checkZeroValues {
    if (widget.otherServicesController.text.trim().isNotEmpty) {
      if (widget.otherServicesController.text.trim() == '0,00') {
        return false;
      }
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    _showOtherServicesDescribeField =
        widget.otherServicesController.text.trim().isNotEmpty &&
            checkZeroValues;
    widget.otherServicesController.addListener(_onOtherServicesChanged);
  }

  @override
  void dispose() {
    widget.otherServicesController.removeListener(_onOtherServicesChanged);
    super.dispose();
  }

  void _onOtherServicesChanged() {
    final hasValue = widget.otherServicesController.text.trim().isNotEmpty &&
        widget.otherServicesController.text != '0,00';
    if (hasValue == _showOtherServicesDescribeField) {
      _notifyFormChanged();
      return;
    }

    setState(() {
      _showOtherServicesDescribeField = hasValue;
      if (!hasValue || (widget.otherServicesController.text != '0,00')) {
        widget.otherServicesDescribeController.clear();
      }
    });
    _notifyFormChanged();
  }

  @override
  Widget build(BuildContext context) {
    final i18n = AppI18n.current;
    const keyboard = TextInputType.numberWithOptions(decimal: true);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildField(
          widget.bankLoansController,
          i18n.expenseBankLoansLabel,
          keyboard,
          helperText: i18n.expenseBankLoansHelper,
        ),
        const SizedBox(height: 24),
        _buildField(
          widget.otherServicesController,
          i18n.expenseLoansOtherServicesLabel,
          keyboard,
          helperText: i18n.expenseLoansOtherServicesHelper,
        ),
        if (_showOtherServicesDescribeField) ...[
          const SizedBox(height: 24),
          SizedBox(
            height: 56,
            child: EbolsaTextField(
              controller: widget.otherServicesDescribeController,
              label: i18n.expenseLoansOtherServicesDescribeLabel,
              keyboardType: TextInputType.text,
            ),
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
            inputFormatters: [MoneyTextInputFormatter()],
          ),
        ),
        if (helperText != null) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
