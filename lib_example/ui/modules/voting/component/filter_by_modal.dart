import 'package:flutter/material.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';
import '../../../helpers/i18n/resources.dart';
import 'costum_filter_option.dart';

class FilterByModal extends StatelessWidget {
  const FilterByModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 467,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
              color: AppColors.primaryLight,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GcText(
              text: R.string.filterByLabel,
              textStyleEnum: GcTextStyleEnum.bold,
              textSize: GcTextSizeEnum.h3,
              color: AppColors.black,
              gcStyles: GcStyles.poppins,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          CostumFilterOption(
                              label: 'ACM', count: '1/1', isSelected: true),
                          SizedBox(height: 8.0),
                          CostumFilterOption(
                              label: 'HM', count: '1/3', isSelected: true),
                          SizedBox(height: 8.0),
                          CostumFilterOption(label: 'PARL', count: '0/2'),
                        ],
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        children: [
                          CostumFilterOption(label: 'PUB', count: '0/1'),
                          SizedBox(height: 8.0),
                          CostumFilterOption(label: 'SSPM', count: '1/1'),
                          SizedBox(height: 8.0),
                          CostumFilterOption(label: 'STW', count: '1/1'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(
            color: AppColors.neutralHighMedium,
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 117,
                    height: 48,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      color: AppColors.neutralLight,
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: GcText(
                      text: R.string.clearAllLabel,
                      textStyleEnum: GcTextStyleEnum.bold,
                      textSize: GcTextSizeEnum.callout,
                      color: AppColors.primaryLight,
                      gcStyles: GcStyles.poppins,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 216,
                    height: 48,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 10.0),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: GcText(
                      text: R.string.applyLabel,
                      textStyleEnum: GcTextStyleEnum.bold,
                      textSize: GcTextSizeEnum.callout,
                      color: AppColors.white,
                      gcStyles: GcStyles.poppins,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
