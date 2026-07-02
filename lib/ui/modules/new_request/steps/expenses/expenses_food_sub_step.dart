import 'package:flutter/material.dart';

import '../../../../../main/i18n/app_i18n.dart';
import '../../../../components/ebolsa_text_field.dart';
import '../../../../helpers/themes/themes.dart';

class ExpensesFoodSubStep extends StatelessWidget {
  const ExpensesFoodSubStep({
    super.key,
    required this.foodValueController,
  });

  final TextEditingController foodValueController;

  @override
  Widget build(BuildContext context) {
    final i18n = AppI18n.current;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 56,
          child: EbolsaTextField(
            controller: foodValueController,
            label: i18n.expenseFoodValueLabel,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            i18n.expenseFoodHelper,
            style: AppTextStyles.bodySmall,
          ),
        ),
      ],
    );
  }
}
