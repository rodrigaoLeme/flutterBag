import 'package:flutter/material.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';

class NotifyMeBottomSheet extends StatelessWidget {
  const NotifyMeBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 275,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.close,
              color: AppColors.black,
            ),
            const SizedBox(height: 16.0),
            GcText(
              text: 'Notify me',
              textSize: GcTextSizeEnum.h4,
              textStyleEnum: GcTextStyleEnum.bold,
              color: AppColors.neutralLowDark,
              gcStyles: GcStyles.poppins,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTimeButton('10 min'),
                  const SizedBox(width: 16.0),
                  _buildTimeButton('15 min'),
                  const SizedBox(width: 16.0),
                  _buildTimeButton('20 min'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  height: 48.0,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.check,
                        color: AppColors.white,
                      ),
                      const SizedBox(width: 8.0),
                      GcText(
                        text: 'Save',
                        textSize: GcTextSizeEnum.body,
                        textStyleEnum: GcTextStyleEnum.bold,
                        color: AppColors.white,
                        gcStyles: GcStyles.poppins,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeButton(String timeText) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          width: 1.0,
          color: AppColors.neutralHighMedium,
        ),
      ),
      child: GcText(
        text: timeText,
        textSize: GcTextSizeEnum.body,
        textStyleEnum: GcTextStyleEnum.bold,
        color: AppColors.primaryLight,
        gcStyles: GcStyles.poppins,
      ),
    );
  }
}
