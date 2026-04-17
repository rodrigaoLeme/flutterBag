import 'package:flutter/material.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';

class ResultCell extends StatelessWidget {
  final String? image;
  final String? name;
  final String? position;
  final String? labelImage;

  const ResultCell({
    super.key,
    required this.image,
    required this.name,
    required this.position,
    required this.labelImage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              padding: const EdgeInsets.all(4.0),
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primaryLight,
                  width: 2,
                ),
              ),
              child: ClipOval(
                child: Image.asset(
                  image ?? '',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: GcText(
                  text: labelImage ?? '',
                  textStyleEnum: GcTextStyleEnum.bold,
                  textSize: GcTextSizeEnum.caption2,
                  color: AppColors.white,
                  gcStyles: GcStyles.poppins,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        GcText(
          text: name ?? '',
          textStyleEnum: GcTextStyleEnum.bold,
          textSize: GcTextSizeEnum.subheadline,
          color: AppColors.black,
          gcStyles: GcStyles.poppins,
        ),
        GcText(
          text: position ?? '',
          textStyleEnum: GcTextStyleEnum.regular,
          textSize: GcTextSizeEnum.caption1,
          color: AppColors.neutralLowMedium,
          gcStyles: GcStyles.poppins,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
