import 'package:flutter/material.dart';

import '../../../../../main/i18n/app_i18n.dart';
import '../../../../components/ebolsa_text_field.dart';
import '../../../../helpers/money_text_input_formatter.dart';
import '../../../../helpers/themes/themes.dart';

class ExpensesAutomobileSubStep extends StatelessWidget {
  const ExpensesAutomobileSubStep({
    super.key,
    required this.ipvaController,
    required this.carInsuranceController,
    required this.vehicleFinancingController,
    this.isVehicleFinancingLocked = false,
  });

  final TextEditingController ipvaController;
  final TextEditingController carInsuranceController;
  final TextEditingController vehicleFinancingController;
  final bool isVehicleFinancingLocked;

  @override
  Widget build(BuildContext context) {
    final i18n = AppI18n.current;
    const keyboard = TextInputType.numberWithOptions(decimal: true);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildField(
          ipvaController,
          i18n.expenseIpvaLabel,
          keyboard,
          helperText: i18n.expenseIptuHelper,
        ),
        const SizedBox(height: 24),
        _buildField(
          carInsuranceController,
          i18n.expenseCarInsuranceLabel,
          keyboard,
          helperText: i18n.expenseIptuHelper,
        ),
        const SizedBox(height: 24),
        _buildField(
          vehicleFinancingController,
          i18n.expenseVehicleFinancingLabel,
          keyboard,
          enabled: !isVehicleFinancingLocked,
        ),
      ],
    );
  }

  Widget _buildField(
    TextEditingController controller,
    String label,
    TextInputType keyboardType, {
    String? helperText,
    bool enabled = true,
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
            enabled: enabled,
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
