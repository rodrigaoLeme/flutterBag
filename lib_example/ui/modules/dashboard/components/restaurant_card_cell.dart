import 'package:flutter/material.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';
import '../../../helpers/helpers.dart';
import '../section_view_model.dart';

class RestaurantCardCell extends StatelessWidget {
  final SectionType type;
  final void Function(SectionType) onTap;

  const RestaurantCardCell({
    super.key,
    required this.type,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        GestureDetector(
          onTap: () {
            onTap(type);
          },
          child: Container(
            width: ResponsiveLayout.of(context).wp(50) - 24,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                width: 1,
                color: AppColors.neutralHighMedium,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: 92,
                        child: Image.asset(
                          type.getImageForSection(isFolder: false),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 18.0),
                  child: GcText(
                    text: type.getTitleForSection(isFolder: false),
                    textSize: GcTextSizeEnum.body,
                    textStyleEnum: GcTextStyleEnum.regular,
                    gcStyles: GcStyles.poppins,
                    color: AppColors.neutralLowDark,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
