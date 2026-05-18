import 'package:flutter/material.dart';

import '../../../../../main/i18n/app_i18n.dart';
import '../../../../helpers/themes/themes.dart';
import '../../../../components/components.dart';

class FamilyStep extends StatelessWidget {
  final int currentSubStep;
  final VoidCallback? onAddMember;

  const FamilyStep({super.key, required this.currentSubStep, this.onAddMember});

  @override
  Widget build(BuildContext context) {
    switch (currentSubStep) {
      case 1:
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(AppI18n.current.peopleHomeLabel,
                        style: AppTextStyles.titleLarge),
                  ),
                  GestureDetector(
                    onTap: () => EbolsaInfoBottomSheet.show(
                      context,
                      iconData: Icons.info_outline,
                      iconColor: AppColors.warning,
                      sections: [
                        EbolsaInfoSection(
                          title: AppI18n.current.familyInfoGroupTitle,
                          description:
                              AppI18n.current.familyInfoGroupDescription,
                        ),
                        EbolsaInfoSection(
                          title: AppI18n.current.familyInfoIncomeTitle,
                          description:
                              AppI18n.current.familyInfoIncomeDescription,
                        ),
                        EbolsaInfoSection(
                          title: AppI18n.current.familyInfoKinshipTitle,
                          description:
                              AppI18n.current.familyInfoKinshipDescription,
                        ),
                      ],
                      closeLabel: AppI18n.current.familyInfoCloseButton,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.info_outline,
                        color: AppColors.warning,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text.rich(
                TextSpan(
                  style: AppTextStyles.bodyMedium,
                  children: [
                    TextSpan(text: AppI18n.current.familyStepDescriptionPrefix),
                    TextSpan(
                      text: AppI18n.current.familyStepDescriptionEmphasis,
                      style: AppTextStyles.bodyMedium
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    TextSpan(text: AppI18n.current.familyStepDescriptionSuffix),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              InkWell(
                onTap: onAddMember,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add,
                          size: 20, color: AppColors.onPrimaryContainer),
                      const SizedBox(width: 8),
                      Text(AppI18n.current.addFamilyMember,
                          style: AppTextStyles.labelLarge
                              .copyWith(color: AppColors.onPrimaryContainer)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );

      case 2:
        return Center(
            child: Text('Family - Substep 2', style: AppTextStyles.titleLarge));

      default:
        return Center(
            child: Text('Family - Other', style: AppTextStyles.titleLarge));
    }
  }
}
