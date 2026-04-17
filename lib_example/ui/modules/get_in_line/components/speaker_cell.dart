import 'package:flutter/material.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';

class SpeakerCell extends StatelessWidget {
  const SpeakerCell({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(right: 8.0),
          child: Icon(
            Icons.account_circle,
            size: 48,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GcText(
                text: 'Marie Smith ',
                textStyleEnum: GcTextStyleEnum.bold,
                textSize: GcTextSizeEnum.subheadline,
                color: AppColors.black,
                gcStyles: GcStyles.poppins,
              ),
              GcText(
                text: 'Product Manager at',
                textStyleEnum: GcTextStyleEnum.regular,
                textSize: GcTextSizeEnum.caption1,
                color: AppColors.neutralLowMedium,
                gcStyles: GcStyles.poppins,
              ),
              GcText(
                text: 'South America Division',
                textStyleEnum: GcTextStyleEnum.regular,
                textSize: GcTextSizeEnum.caption1,
                color: AppColors.neutralLowMedium,
                gcStyles: GcStyles.poppins,
              ),
            ],
          ),
        ),
        Row(
          children: [
            TextButton(
              onPressed: () {},
              child: GcText(
                text: 'connect',
                textStyleEnum: GcTextStyleEnum.semibold,
                textSize: GcTextSizeEnum.subheadline,
                color: AppColors.primaryLight,
                gcStyles: GcStyles.poppins,
              ),
            ),
          ],
        )
      ],
    );
  }
}
