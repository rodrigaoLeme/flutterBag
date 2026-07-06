import 'package:flutter/material.dart';

import '../../../../../../main/i18n/app_i18n.dart';
import '../../../../../helpers/themes/themes.dart';
import '../member_registration_view_model.dart';

class MemberRegistrationDialogs {
  const MemberRegistrationDialogs._();

  static Future<bool?> showSummaryBackDialog(BuildContext context) {
    final i18n = AppI18n.current;

    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundLight,
        title: Text(
          i18n.familyConfirmDialogTitle,
          style: AppTextStyles.titleLarge,
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(i18n.summaryAdvanceDialogBody1,
                  style: AppTextStyles.bodyMedium),
              const SizedBox(height: 16),
              Text(i18n.summaryAdvanceDialogBody2,
                  style: AppTextStyles.bodyMedium),
              const SizedBox(height: 16),
              Text(i18n.summaryAdvanceDialogQuestion,
                  style: AppTextStyles.bodyMedium),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              i18n.answerNo,
              style:
                  AppTextStyles.titleSmall.copyWith(color: AppColors.primary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              i18n.summaryAdvanceDialogConfirm,
              style:
                  AppTextStyles.titleSmall.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  static Future<bool?> showFamilyMembersConfirmDialog(
    BuildContext context,
    MemberRegistrationViewModel vm,
  ) {
    final i18n = AppI18n.current;
    const underline = TextStyle(decoration: TextDecoration.underline);

    return showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: AppColors.backgroundLight,
        insetPadding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: SizedBox(
          width: 354,
          height: 460,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                child: Text(
                  i18n.familyConfirmDialogTitle,
                  style: AppTextStyles.titleLarge,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          style: AppTextStyles.bodyMedium,
                          children: [
                            TextSpan(
                              text: i18n.familyConfirmDialogBodyEmphasis1,
                              style: underline.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                            TextSpan(text: i18n.familyConfirmDialogBodyMiddle),
                            TextSpan(
                              text: i18n.familyConfirmDialogBodyEmphasis2,
                              style: underline.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                            TextSpan(text: i18n.familyConfirmDialogBodySuffix),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        i18n.familyConfirmDialogMembersIntro,
                        style: AppTextStyles.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      for (final member in vm.addedFamilyMembers)
                        Padding(
                          padding: const EdgeInsets.only(left: 8, bottom: 4),
                          child: Text(
                            '• ${member['cpf']} - ${member['name']}'
                            '${member['isScholarshipCandidate'] == true ? ' (${i18n.scholarshipCandidateTag})' : ''}',
                            style: AppTextStyles.bodyMedium,
                          ),
                        ),
                      const SizedBox(height: 16),
                      Text(
                        i18n.familyConfirmDialogQuestion,
                        style: AppTextStyles.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(
                        i18n.familyConfirmDialogReview,
                        style: AppTextStyles.titleSmall.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(
                        i18n.familyConfirmDialogContinue,
                        style: AppTextStyles.titleSmall.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<bool?> showOccupationDeleteDialog(
    BuildContext context,
    String occupationName,
  ) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundLight,
        title: Text('Confirmação', style: AppTextStyles.titleLarge),
        content: Text(
          'Tem certeza que deseja excluir "$occupationName" como ocupação?',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Não', style: AppTextStyles.bodyMedium),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Sim',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Future<bool?> showChildSupportInfoDialog(BuildContext context) {
    final i18n = AppI18n.current;

    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundLight,
        title: Text(i18n.familyConfirmDialogTitle, style: AppTextStyles.titleLarge),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(i18n.childSupportInfoDialogBody1,
                  style: AppTextStyles.bodyMedium),
              const SizedBox(height: 16),
              Text(i18n.childSupportInfoDialogBody2,
                  style: AppTextStyles.bodyMedium),
              const SizedBox(height: 16),
              Text(i18n.childSupportInfoDialogBody3,
                  style: AppTextStyles.bodyMedium),
              const SizedBox(height: 16),
              Text(i18n.childSupportInfoDialogBody4,
                  style: AppTextStyles.bodyMedium),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              i18n.createAccountDialogDoneButton,
              style: AppTextStyles.m3LabelLarge.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Future<bool?> showInssBenefitInfoDialog(BuildContext context) {
    final i18n = AppI18n.current;

    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundLight,
        title: Text(i18n.familyConfirmDialogTitle, style: AppTextStyles.titleLarge),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(i18n.inssBenefitInfoDialogBody1,
                  style: AppTextStyles.bodyMedium),
              const SizedBox(height: 16),
              Text(i18n.inssBenefitInfoDialogBody2,
                  style: AppTextStyles.bodyMedium),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              i18n.createAccountDialogDoneButton,
              style: AppTextStyles.m3LabelLarge.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
