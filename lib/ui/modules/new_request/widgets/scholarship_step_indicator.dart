import 'package:flutter/material.dart';

import '../../../helpers/themes/themes.dart';

typedef StepTapCallback = void Function(int step);

class ScholarshipStepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String> labels;
  final StepTapCallback? onStepTap;

  const ScholarshipStepIndicator({
    super.key,
    required this.currentStep,
    this.totalSteps = 5,
    this.labels = const [
      'Moradia',
      'Família',
      'Despesas',
      'Candidato',
      'Docuemntos',
    ],
    this.onStepTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(totalSteps, (index) {
          final step = index + 1;
          final label = labels.length > index ? labels[index] : '$step';
          final isCompleted = step < currentStep;
          final isActive = step == currentStep;

          Widget child;

          if (isCompleted) {
            child = Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$step',
                style: AppTextStyles.labelLarge.copyWith(color: Colors.white),
              ),
            );
          } else if (isActive) {
            child = Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.secondaryContainer,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                '$step - $label',
                style: AppTextStyles.labelLarge
                    .copyWith(color: AppColors.textPrimaryLight),
              ),
            );
          } else {
            child = Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$step',
                style: AppTextStyles.labelLarge
                    .copyWith(color: AppColors.textPrimaryLight),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () => onStepTap?.call(step),
              child: child,
            ),
          );
        }),
      ),
    );
  }
}
