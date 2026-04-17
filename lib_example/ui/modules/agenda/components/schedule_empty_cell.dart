import 'package:flutter/material.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';
import '../../../helpers/i18n/resources.dart';

class ScheduleEmptyCell extends StatelessWidget {
  const ScheduleEmptyCell({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GcText(
                  text: '',
                  textSize: GcTextSizeEnum.callout,
                  textStyleEnum: GcTextStyleEnum.regular,
                  gcStyles: GcStyles.poppins,
                  color: AppColors.neutralLowMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: GcText(
                  text: R.string.programmingNotAvailable,
                  textSize: GcTextSizeEnum.callout,
                  textStyleEnum: GcTextStyleEnum.regular,
                  gcStyles: GcStyles.poppins,
                  color: AppColors.neutralLowMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: GcText(
                  text: '',
                  textSize: GcTextSizeEnum.callout,
                  textStyleEnum: GcTextStyleEnum.regular,
                  gcStyles: GcStyles.poppins,
                  color: AppColors.neutralLowMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
