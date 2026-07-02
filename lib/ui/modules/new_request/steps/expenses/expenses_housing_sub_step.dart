import 'package:flutter/material.dart';

import '../../../../../main/i18n/app_i18n.dart';
import '../../../../components/ebolsa_text_field.dart';
import '../../../../helpers/themes/themes.dart';

const int expensesSubStepCount = 6;

String expensesSubStepNavTitle(int subStep) {
  final i18n = AppI18n.current;

  switch (subStep) {
    case 1:
      return i18n.housingLabel;
    case 2:
      return i18n.expensesFoodSubStepNavTitle;
    case 3:
      return i18n.expensesHealthSubStepNavTitle;
    case 4:
      return i18n.expensesEducationSubStepNavTitle;
    case 5:
      return i18n.expensesAutomobileSubStepNavTitle;
    case 6:
      return i18n.expensesLoansSubStepNavTitle;
    default:
      return 'Substep $subStep';
  }
}

class ExpensesHousingSubStep extends StatelessWidget {
  const ExpensesHousingSubStep({
    super.key,
    required this.rentController,
    required this.financingController,
    required this.iptuController,
    required this.condoController,
    required this.electricityController,
    required this.waterController,
    required this.gasController,
    required this.phoneInternetController,
  });

  final TextEditingController rentController;
  final TextEditingController financingController;
  final TextEditingController iptuController;
  final TextEditingController condoController;
  final TextEditingController electricityController;
  final TextEditingController waterController;
  final TextEditingController gasController;
  final TextEditingController phoneInternetController;

  @override
  Widget build(BuildContext context) {
    final i18n = AppI18n.current;
    const keyboard = TextInputType.numberWithOptions(decimal: true);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildField(rentController, i18n.expenseRentValueLabel, keyboard),
        const SizedBox(height: 12),
        _buildField(
          financingController,
          i18n.expenseFinancingValueLabel,
          keyboard,
        ),
        const SizedBox(height: 12),
        _buildField(
          iptuController,
          i18n.expenseIptuValueLabel,
          keyboard,
          helperText: i18n.expenseIptuHelper,
        ),
        const SizedBox(height: 12),
        _buildField(condoController, i18n.expenseCondoValueLabel, keyboard),
        const SizedBox(height: 12),
        _buildField(
          electricityController,
          i18n.expenseElectricityValueLabel,
          keyboard,
        ),
        const SizedBox(height: 12),
        _buildField(waterController, i18n.expenseWaterValueLabel, keyboard),
        const SizedBox(height: 12),
        _buildField(gasController, i18n.expenseGasValueLabel, keyboard),
        const SizedBox(height: 12),
        _buildField(
          phoneInternetController,
          i18n.expensePhoneInternetValueLabel,
          keyboard,
          helperText: i18n.expensePhoneInternetHelper,
        ),
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
