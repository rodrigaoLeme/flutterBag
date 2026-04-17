import 'package:flutter/material.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';
import '../../../helpers/i18n/resources.dart';

class TourismInfo extends StatelessWidget {
  const TourismInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.onSecundaryContainer,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 160,
                decoration: const BoxDecoration(
                  color: AppColors.onSecundaryContainer,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                child: GcText(
                  text: 'The Gateway Arch',
                  textStyleEnum: GcTextStyleEnum.semibold,
                  textSize: GcTextSizeEnum.h3,
                  color: AppColors.primaryLight,
                  gcStyles: GcStyles.poppins,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GcText(
                  text: 'Park • 5,3 miles ',
                  textStyleEnum: GcTextStyleEnum.regular,
                  textSize: GcTextSizeEnum.subheadline,
                  color: AppColors.black,
                  gcStyles: GcStyles.poppins,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0, left: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GcText(
                      text: R.string.save,
                      textStyleEnum: GcTextStyleEnum.semibold,
                      textSize: GcTextSizeEnum.h3,
                      color: AppColors.primaryLight,
                      gcStyles: GcStyles.poppins,
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                        elevation: 2.0,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.arrow_circle_right,
                            color: AppColors.primaryLight,
                            size: 13.0,
                          ),
                          const SizedBox(width: 8),
                          GcText(
                            text: R.string.directionsLabel,
                            textStyleEnum: GcTextStyleEnum.semibold,
                            textSize: GcTextSizeEnum.subheadline,
                            color: AppColors.primaryLight,
                            gcStyles: GcStyles.poppins,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
