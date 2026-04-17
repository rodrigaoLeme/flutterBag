import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';
import '../../../helpers/i18n/resources.dart';

class CardPrayerSession extends StatelessWidget {
  const CardPrayerSession({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TODAY  •  08:50 AM - 09:15 AM',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Prayer Session',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              SvgPicture.asset(
                'lib/ui/assets/images/icon/location_light.svg',
                height: 14,
                width: 14,
                color: AppColors.white,
              ),
              const SizedBox(width: 4),
              GcText(
                text: 'The Stadium',
                gcStyles: GcStyles.poppins,
                textSize: GcTextSizeEnum.callout,
                textStyleEnum: GcTextStyleEnum.regular,
                color: AppColors.white,
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.inverseOnSurface,
                  foregroundColor: AppColors.primaryLight,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                icon: SvgPicture.asset(
                  'lib/ui/assets/images/icon/diamond-turn-right-solid.svg',
                  height: 20,
                  width: 20,
                  color: AppColors.primaryLight,
                ),
                label: GcText(
                  text: R.string.locationLabel,
                  gcStyles: GcStyles.poppins,
                  textSize: GcTextSizeEnum.callout,
                  textStyleEnum: GcTextStyleEnum.regular,
                  color: AppColors.primaryLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
