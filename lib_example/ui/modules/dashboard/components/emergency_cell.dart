import 'package:flutter/material.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';
import '../../../helpers/i18n/resources.dart';

class EmergencyCell extends StatelessWidget {
  const EmergencyCell({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Builder(builder: (context) {
          return Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GcText(
                  text: R.string.emergencyNumberLabel,
                  textSize: GcTextSizeEnum.subheadline,
                  textStyleEnum: GcTextStyleEnum.bold,
                  gcStyles: GcStyles.poppins,
                  color: AppColors.black,
                  textAlign: TextAlign.center,
                ),
                GcText(
                  text: '',
                  textSize: GcTextSizeEnum.subheadline,
                  textStyleEnum: GcTextStyleEnum.semibold,
                  gcStyles: GcStyles.poppins,
                  color: AppColors.black,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }),
        Container(
          height: 44,
          width: 44,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.denimLigth,
          ),
          child: Icon(
            Icons.phone,
            color: AppColors.primaryLight,
          ),
        )
      ],
    );
  }
}
