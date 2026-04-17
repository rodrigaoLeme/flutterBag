import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';
import '../../../helpers/i18n/resources.dart';

class EmergencySMS extends StatelessWidget {
  final void Function(BuildContext) show;

  const EmergencySMS({
    required this.show,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: AppColors.neutralHigh,
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GcText(
              text: R.string.receiveSMSLabel,
              textSize: GcTextSizeEnum.callout,
              textStyleEnum: GcTextStyleEnum.bold,
              gcStyles: GcStyles.poppins,
              color: AppColors.primaryLight,
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                show(context);
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.neutralLight,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          'lib/ui/assets/images/icon/phone-light.svg',
                          height: 14,
                          width: 14,
                          fit: BoxFit.fill,
                          color: AppColors.primaryLight,
                        ),
                        const SizedBox(width: 8),
                        GcText(
                          text: R.string.addPhoneLabel,
                          textSize: GcTextSizeEnum.subheadlineW400,
                          textStyleEnum: GcTextStyleEnum.regular,
                          gcStyles: GcStyles.poppins,
                          color: AppColors.primaryLight,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
