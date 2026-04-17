import 'package:flutter/material.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';

class UserDetails extends StatelessWidget {
  const UserDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.account_circle,
              size: 128.0,
              color: AppColors.onSecundaryContainer,
            ),
            GcText(
              text: 'Pr. Jonas Williams',
              textStyleEnum: GcTextStyleEnum.bold,
              textSize: GcTextSizeEnum.h2,
              color: AppColors.black,
              gcStyles: GcStyles.poppins,
            ),
            GcText(
              text: 'Delegate',
              textStyleEnum: GcTextStyleEnum.regular,
              textSize: GcTextSizeEnum.callout,
              color: AppColors.black,
              gcStyles: GcStyles.poppins,
            ),
            GcText(
              text: 'Australian Union - Australian',
              textStyleEnum: GcTextStyleEnum.regular,
              textSize: GcTextSizeEnum.callout,
              color: AppColors.black,
              gcStyles: GcStyles.poppins,
            ),
          ],
        ),
      ),
    );
  }
}
