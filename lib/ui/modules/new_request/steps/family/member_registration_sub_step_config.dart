import 'package:flutter/material.dart';

import '../../../../../main/i18n/app_i18n.dart';
import '../../../../helpers/themes/themes.dart';

class MemberRegistrationSubStepConfig {
  const MemberRegistrationSubStepConfig({
    required this.navTitle,
    required this.headerTitle,
    this.headerDescription,
    this.headerDescriptionWidget,
    this.showFamilyInfoIcon = false,
  });

  final String navTitle;
  final String headerTitle;
  final String? headerDescription;
  final Widget? headerDescriptionWidget;
  final bool showFamilyInfoIcon;
}

const int memberRegistrationSubStepCount = 6;

MemberRegistrationSubStepConfig memberRegistrationSubStepConfig(int subStep) {
  final i18n = AppI18n.current;

  switch (subStep) {
    case 1:
      return MemberRegistrationSubStepConfig(
        navTitle: i18n.personalDataTitle,
        headerTitle: i18n.memberRegistrationTitle,
        headerDescription: i18n.memberRegistrationDescription,
      );
    case 2:
      return MemberRegistrationSubStepConfig(
        navTitle: i18n.occupationTitle,
        headerTitle: i18n.memberRegistrationTitle,
        headerDescription: i18n.occupationStepDescription,
      );
    case 3:
      return MemberRegistrationSubStepConfig(
        navTitle: i18n.otherIncomeSubStepNavTitle,
        headerTitle: i18n.memberRegistrationTitle,
        headerDescription: i18n.otherIncomeMemberStepDescription,
      );
    case 4:
      return MemberRegistrationSubStepConfig(
        navTitle: i18n.familyMembersSubStepNavTitle,
        headerTitle: i18n.peopleHomeLabel,
        headerDescriptionWidget: Text.rich(
          TextSpan(
            style: AppTextStyles.bodyMedium,
            children: [
              TextSpan(text: i18n.familyStepDescriptionPrefix),
              TextSpan(
                text: i18n.familyStepDescriptionEmphasis,
                style: AppTextStyles.bodyMedium
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              TextSpan(text: i18n.familyStepDescriptionSuffix),
            ],
          ),
        ),
        showFamilyInfoIcon: true,
      );
    case 5:
      return MemberRegistrationSubStepConfig(
        navTitle: i18n.assetsRelationSubStepNavTitle,
        headerTitle: i18n.otherIncomeStepTitle,
        headerDescription: i18n.otherIncomeStepDescription,
      );
    case 6:
      return MemberRegistrationSubStepConfig(
        navTitle: i18n.summarySubStepNavTitle,
        headerTitle: i18n.otherIncomeStepTitle,
        headerDescription: i18n.summaryStepDescription,
      );
    default:
      throw RangeError('Invalid member registration substep: $subStep');
  }
}
