import 'package:flutter/material.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';

class EventInfoCell extends StatelessWidget {
  const EventInfoCell({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Column(
            children: [
              GcText(
                text: 'MON',
                textSize: GcTextSizeEnum.footnote,
                textStyleEnum: GcTextStyleEnum.regular,
                gcStyles: GcStyles.poppins,
              ),
              GcText(
                text: '3:15 pm',
                textSize: GcTextSizeEnum.footnote,
                textStyleEnum: GcTextStyleEnum.regular,
                gcStyles: GcStyles.poppins,
              ),
              GcText(
                text: '4:00 pm',
                textSize: GcTextSizeEnum.footnote,
                textStyleEnum: GcTextStyleEnum.regular,
                gcStyles: GcStyles.poppins,
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GcText(
                    text:
                        'Navigating high-risk opportunities as a tech disruptor',
                    textSize: GcTextSizeEnum.callout,
                    textStyleEnum: GcTextStyleEnum.regular,
                    gcStyles: GcStyles.poppins,
                    color: AppColors.white,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: GcText(
                      text: 'Marie Smith (SAD), John Doe(GC)',
                      textSize: GcTextSizeEnum.subheadline,
                      textStyleEnum: GcTextStyleEnum.regular,
                      gcStyles: GcStyles.poppins,
                      color: AppColors.white,
                    ),
                  ),
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 4.0),
                        child: Icon(
                          Icons.place,
                          color: AppColors.white,
                          size: 12,
                        ),
                      ),
                      Expanded(
                        child: GcText(
                          text: '4° Floor Main Hall',
                          textSize: GcTextSizeEnum.subheadline,
                          textStyleEnum: GcTextStyleEnum.regular,
                          gcStyles: GcStyles.poppins,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
