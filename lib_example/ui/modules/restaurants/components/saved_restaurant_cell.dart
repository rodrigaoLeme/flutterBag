import 'package:flutter/material.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';
import '../../../helpers/i18n/resources.dart';

class SavedRestaurantCell extends StatelessWidget {
  const SavedRestaurantCell({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.neutralLight,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 64,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
              color: AppColors.onSecundaryContainer,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0, bottom: 16),
                    child: GcText(
                      text: R.string.restaurantsLabel,
                      textStyleEnum: GcTextStyleEnum.semibold,
                      textSize: GcTextSizeEnum.subheadline,
                      color: AppColors.primaryLight,
                      gcStyles: GcStyles.poppins,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.place,
                          size: 16,
                          color: AppColors.primaryLight,
                        ),
                        const SizedBox(width: 4),
                        GcText(
                          text: '2,5 miles',
                          textStyleEnum: GcTextStyleEnum.regular,
                          textSize: GcTextSizeEnum.footnote,
                          color: AppColors.primaryLight,
                          gcStyles: GcStyles.poppins,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0, right: 12),
            child: Icon(
              Icons.bookmark,
              color: AppColors.primaryLight,
            ),
          ),
        ],
      ),
    );
  }
}
