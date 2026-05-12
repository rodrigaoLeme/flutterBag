import 'package:flutter/material.dart';

import '../../../../helpers/themes/themes.dart';

class CandidateStep extends StatelessWidget {
  final int currentSubStep;

  const CandidateStep({super.key, required this.currentSubStep});

  @override
  Widget build(BuildContext context) {
    switch (currentSubStep) {
      case 0:
        return Center(
            child:
                Text('Candidate - Substep 0', style: AppTextStyles.titleLarge));
      default:
        return Center(
            child: Text('Candidate - Other', style: AppTextStyles.titleLarge));
    }
  }
}
