import 'package:flutter/material.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';

class CostumFilterOption extends StatelessWidget {
  final String label;
  final String count;
  final bool isSelected;

  const CostumFilterOption({
    Key? key,
    required this.label,
    required this.count,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 176,
      height: 72,
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryLight : AppColors.neutralLight,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: GcText(
              text: label,
              textStyleEnum: GcTextStyleEnum.bold,
              textSize: GcTextSizeEnum.callout,
              color: isSelected ? AppColors.white : AppColors.black,
              gcStyles: GcStyles.poppins,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GcText(
              text: count,
              textStyleEnum: GcTextStyleEnum.regular,
              textSize: GcTextSizeEnum.caption1,
              color: isSelected ? AppColors.white : AppColors.black,
              gcStyles: GcStyles.poppins,
            ),
          ),
        ],
      ),
    );
  }
}
