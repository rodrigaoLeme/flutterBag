import 'package:flutter/material.dart';

import '../../../../share/utils/app_color.dart';
import '../helpers/i18n/resources.dart';
import 'enum/design_system_enums.dart';
import 'gc_text.dart';
import 'themes/gc_styles.dart';

class ErrorActionSheet extends StatelessWidget {
  const ErrorActionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 232,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
            top: 32.0, left: 16.0, right: 16.0, bottom: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GcText(
              text: R.string.somethingWrongTitle,
              textStyleEnum: GcTextStyleEnum.bold,
              textSize: GcTextSizeEnum.h2,
              color: AppColors.black,
              gcStyles: GcStyles.poppins,
            ),
            const SizedBox(height: 8.0),
            GcText(
              text: R.string.somethingWrongSubtitle,
              textStyleEnum: GcTextStyleEnum.regular,
              textSize: GcTextSizeEnum.callout,
              color: AppColors.neutralLowDark,
              gcStyles: GcStyles.poppins,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Center(
                child: SizedBox(
                  width: 372,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.redMedium,
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                    ),
                    child: GcText(
                      text: 'Try again',
                      textStyleEnum: GcTextStyleEnum.bold,
                      textSize: GcTextSizeEnum.callout,
                      color: AppColors.white,
                      gcStyles: GcStyles.poppins,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
