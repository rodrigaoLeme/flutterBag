import 'package:flutter/material.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';

class ChangeImage extends StatelessWidget {
  const ChangeImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
        color: AppColors.white,
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(top: 24.0, left: 16.0),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Icon(
                      Icons.photo_library,
                      size: 28.0,
                    ),
                  ),
                  GcText(
                    text: 'Gallery ',
                    textSize: GcTextSizeEnum.h4,
                    textStyleEnum: GcTextStyleEnum.regular,
                    color: AppColors.black,
                    gcStyles: GcStyles.poppins,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(
              color: Theme.of(context).disabledColor,
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Icon(
                      Icons.camera_alt,
                      size: 28.0,
                    ),
                  ),
                  GcText(
                    text: 'Camera ',
                    textSize: GcTextSizeEnum.h4,
                    textStyleEnum: GcTextStyleEnum.regular,
                    color: AppColors.black,
                    gcStyles: GcStyles.poppins,
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
