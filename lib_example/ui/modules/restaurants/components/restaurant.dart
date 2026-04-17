import 'package:flutter/material.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';
import '../../../helpers/i18n/resources.dart';
import 'components.dart';

class Restaurant extends StatelessWidget {
  const Restaurant({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: GcText(
            text: R.string.savedRestaurantsLabel,
            textStyleEnum: GcTextStyleEnum.bold,
            textSize: GcTextSizeEnum.h2,
            color: AppColors.black,
            gcStyles: GcStyles.poppins,
          ),
        ),
        const Expanded(
          child: SavedRestaurantSection(),
        )
      ],
    );
  }
}
