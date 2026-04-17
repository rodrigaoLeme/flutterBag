import 'package:flutter/material.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';

class FilterCell extends StatelessWidget {
  final String title;
  final Color color;
  const FilterCell({
    super.key,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: color,
      ),
      child: Center(
        child: GcText(
          text: title,
          textSize: GcTextSizeEnum.subheadline,
          textStyleEnum: GcTextStyleEnum.bold,
          gcStyles: GcStyles.poppins,
          color: AppColors.redMedium,
        ),
      ),
    );
  }
}
