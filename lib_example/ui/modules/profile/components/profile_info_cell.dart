import 'package:flutter/material.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';

class ProfileInfoCell extends StatelessWidget {
  const ProfileInfoCell({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GcText(
              text: 'John Doe',
              textStyleEnum: GcTextStyleEnum.semibold,
              textSize: GcTextSizeEnum.callout,
              color: AppColors.primaryLight,
              gcStyles: GcStyles.poppins,
            ),
            Icon(
              Icons.visibility,
              size: 16,
              color: AppColors.primaryLight,
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Divider(),
        ),
      ],
    );
  }
}
