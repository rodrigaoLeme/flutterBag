import 'package:flutter/material.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';
import '../notification_view_model.dart';

class NotificationDetails extends StatelessWidget {
  final NotificationResultViewModel viewModel;

  const NotificationDetails({
    super.key,
    required this.viewModel,
  });
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * viewModel.heightFactor,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12.0, bottom: 16.0),
            child: Center(
              child: Container(
                width: 100,
                height: 3,
                decoration: BoxDecoration(
                  color: AppColors.neutralLowMedium,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GcText(
                    text: viewModel.title ?? '',
                    textStyleEnum: GcTextStyleEnum.bold,
                    textSize: GcTextSizeEnum.h3,
                    color: AppColors.black,
                    gcStyles: GcStyles.poppins,
                    textAlign: TextAlign.left,
                  ),
                  GcText(
                    text: viewModel.formatNotificationDate,
                    textStyleEnum: GcTextStyleEnum.regular,
                    textSize: GcTextSizeEnum.subheadline,
                    color: AppColors.neutralLowMedium,
                    gcStyles: GcStyles.poppins,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 32.0),
                    child: GcText(
                      text: viewModel.body ?? '',
                      textStyleEnum: GcTextStyleEnum.regular,
                      textSize: GcTextSizeEnum.callout,
                      color: AppColors.black,
                      gcStyles: GcStyles.poppins,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
