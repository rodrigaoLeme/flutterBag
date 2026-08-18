import 'package:flutter/material.dart';

import '../../../../../main/i18n/app_i18n.dart';
import '../../../../components/ebolsa_button.dart';
import '../../../../helpers/themes/themes.dart';
import 'other_income_source_page.dart';

class OtherIncomeNoneConfirmationPage extends StatefulWidget {
  const OtherIncomeNoneConfirmationPage({super.key});

  @override
  State<OtherIncomeNoneConfirmationPage> createState() =>
      _OtherIncomeNoneConfirmationPageState();
}

class _OtherIncomeNoneConfirmationPageState
    extends State<OtherIncomeNoneConfirmationPage> {
  bool _declared = false;

  @override
  Widget build(BuildContext context) {
    final i18n = AppI18n.current;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(i18n.otherIncomeNoneConfirmationAppBarTitle),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(false),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      i18n.otherIncomeNoneConfirmationTitle,
                      style: AppTextStyles.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    Text.rich(
                      TextSpan(
                        style: AppTextStyles.bodyMedium,
                        children: [
                          TextSpan(
                            text: i18n.otherIncomeNoneConfirmationDescriptionPrefix,
                          ),
                          TextSpan(
                            text: i18n.otherIncomeNoneConfirmationCancelHighlight,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(
                            text: i18n.otherIncomeNoneConfirmationDescriptionMiddle,
                          ),
                          TextSpan(
                            text: i18n.otherIncomeNoneConfirmationYesHighlight,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(
                            text: i18n.otherIncomeNoneConfirmationDescriptionSuffix,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    for (final type in OtherIncomeSourcePage.incomeTypes)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.check,
                              size: 20,
                              color: AppColors.onSurface,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                type,
                                style: AppTextStyles.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 8),
                    const Divider(height: 1, color: Color(0xFFB9BDC6)),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: _declared,
                            onChanged: (value) {
                              setState(() => _declared = value ?? false);
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() => _declared = !_declared);
                            },
                            child: Text(
                              i18n.otherIncomeNoneDeclarationLabel,
                              style: AppTextStyles.bodyMedium,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                        side: const BorderSide(color: Color(0xFFB9BDC6)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: Text(
                        i18n.newScholarshipDialogCancel,
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColors.onSurface,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: EbolsaButton(
                      onPressed: _declared
                          ? () => Navigator.of(context).pop(true)
                          : null,
                      label: i18n.confirmAction,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
