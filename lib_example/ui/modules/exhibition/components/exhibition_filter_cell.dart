import 'package:flutter/material.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';
import '../../../helpers/i18n/resources.dart';

class ExhibitionFilterCell extends StatelessWidget {
  const ExhibitionFilterCell({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      width: 72.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: AppColors.primaryLight),
      child: Center(
        child: GcText(
          text: R.string.allLabel,
          textSize: GcTextSizeEnum.subheadline,
          textStyleEnum: GcTextStyleEnum.bold,
          color: AppColors.white,
          gcStyles: GcStyles.poppins,
        ),
      ),
    );
  }
}
