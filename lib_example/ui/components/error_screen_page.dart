import 'package:flutter/material.dart';

import '../../share/utils/app_color.dart';
import '../helpers/i18n/resources.dart';
import 'enum/design_system_enums.dart';
import 'error_action_sheet.dart';
import 'gc_text.dart';
import 'themes/gc_styles.dart';

class ErrorScreenPage extends StatelessWidget {
  const ErrorScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'lib/ui/assets/images/icon/error_icon.png',
                  height: 48,
                  width: 48,
                  color: AppColors.redPdf,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40.0, bottom: 16.0),
                  child: GcText(
                    text: R.string.messageErrorLabel,
                    textStyleEnum: GcTextStyleEnum.bold,
                    textSize: GcTextSizeEnum.h1,
                    color: AppColors.redPdf,
                    gcStyles: GcStyles.poppins,
                  ),
                ),
                GcText(
                  text: R.string.messageErrorSubtitle,
                  textStyleEnum: GcTextStyleEnum.regular,
                  textSize: GcTextSizeEnum.callout,
                  color: AppColors.neutralLowDark,
                  gcStyles: GcStyles.poppins,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 32.0,
            left: 0,
            right: 0,
            child: Center(
              child: TextButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => const ErrorActionSheet(),
                  );
                },
                child: GcText(
                  text: R.string.tryAgainLabel,
                  textStyleEnum: GcTextStyleEnum.semibold,
                  textSize: GcTextSizeEnum.callout,
                  color: AppColors.redPdf,
                  gcStyles: GcStyles.poppins,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
