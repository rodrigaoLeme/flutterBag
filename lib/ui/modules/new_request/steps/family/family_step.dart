import 'package:flutter/material.dart';

import '../../../../helpers/themes/themes.dart';

class FamilyStep extends StatelessWidget {
  final int currentSubStep;

  const FamilyStep({super.key, required this.currentSubStep});

  @override
  Widget build(BuildContext context) {
    switch (currentSubStep) {
      case 0:
        return Center(
            child: Text('Family - Substep 0', style: AppTextStyles.titleLarge));
      case 1:
        return Center(
            child: Text('Family - Substep 1', style: AppTextStyles.titleLarge));
      default:
        return Center(
            child: Text('Family - Other', style: AppTextStyles.titleLarge));
    }
  }
}
