import 'package:flutter/material.dart';

import '../../../../helpers/themes/themes.dart';

class DocumentsStep extends StatelessWidget {
  final int currentSubStep;

  const DocumentsStep({super.key, required this.currentSubStep});

  @override
  Widget build(BuildContext context) {
    switch (currentSubStep) {
      case 0:
        return Center(
            child:
                Text('Documents - Substep 0', style: AppTextStyles.titleLarge));
      default:
        return Center(
            child: Text('Documents - Other', style: AppTextStyles.titleLarge));
    }
  }
}
