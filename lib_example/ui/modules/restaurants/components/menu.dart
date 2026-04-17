import 'package:flutter/material.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: GcText(
            text: 'Lunch, Monday June 6',
            textStyleEnum: GcTextStyleEnum.bold,
            textSize: GcTextSizeEnum.h2,
            color: AppColors.black,
            gcStyles: GcStyles.poppins,
          ),
        ),
        GcText(
          text:
              'Salad: Fresh shaved cabbage salad with fresh lime juice, cilantro and sweet diced onions Roasted Red Pepper Hummus and Plain Hummus with Garlic.',
          textStyleEnum: GcTextStyleEnum.bold,
          textSize: GcTextSizeEnum.subheadline,
          color: AppColors.onSecundaryContainer,
          gcStyles: GcStyles.poppins,
        ),
      ],
    );
  }
}
