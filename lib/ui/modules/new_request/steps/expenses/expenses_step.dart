import 'package:flutter/material.dart';

import '../../../../helpers/themes/themes.dart';

class ExpensesStep extends StatelessWidget {
  final int currentSubStep;

  const ExpensesStep({super.key, required this.currentSubStep});

  @override
  Widget build(BuildContext context) {
    switch (currentSubStep) {
      case 0:
        return Center(
            child:
                Text('Expenses - Substep 0', style: AppTextStyles.titleLarge));
      default:
        return Center(
            child: Text('Expenses - Other', style: AppTextStyles.titleLarge));
    }
  }
}
