import 'package:flutter/material.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GcText(
            text: 'Lunch, Monday June 6',
            textStyleEnum: GcTextStyleEnum.bold,
            textSize: GcTextSizeEnum.h3,
            color: AppColors.black,
            gcStyles: GcStyles.poppins,
          ),
          const SizedBox(height: 24),
          GcText(
            text: 'Salad:',
            textStyleEnum: GcTextStyleEnum.bold,
            textSize: GcTextSizeEnum.h4,
            color: AppColors.black,
            gcStyles: GcStyles.poppins,
          ),
          const SizedBox(height: 4),
          GcText(
            text:
                'Fresh shaved cabbage salad with fresh lime juice, cilantro and sweet diced onions\n'
                'Roasted Red Pepper Hummus and Plain Hummus with Garlic.',
            textStyleEnum: GcTextStyleEnum.regular,
            textSize: GcTextSizeEnum.callout,
            color: AppColors.black,
            gcStyles: GcStyles.poppins,
          ),
          const SizedBox(height: 16),
          GcText(
            text: 'Dipping Vegetables:',
            textStyleEnum: GcTextStyleEnum.regular,
            textSize: GcTextSizeEnum.h4,
            color: AppColors.black,
            gcStyles: GcStyles.poppins,
          ),
          const SizedBox(height: 4),
          GcText(
            text: 'Carrot and Celery sticks, and different Pepper Strips.',
            textStyleEnum: GcTextStyleEnum.regular,
            textSize: GcTextSizeEnum.callout,
            color: AppColors.black,
            gcStyles: GcStyles.poppins,
          ),
          const SizedBox(height: 16),
          GcText(
            text: 'Main Dishes:',
            textStyleEnum: GcTextStyleEnum.bold,
            textSize: GcTextSizeEnum.h4,
            color: AppColors.black,
            gcStyles: GcStyles.poppins,
          ),
          const SizedBox(height: 4),
          GcText(
            text:
                'Hearty lentil rice soup with fresh diced carrots with coconut or tomato base\n'
                'Long grain white rice mixed with brown rice',
            textStyleEnum: GcTextStyleEnum.regular,
            textSize: GcTextSizeEnum.callout,
            color: AppColors.black,
            gcStyles: GcStyles.poppins,
          ),
          const SizedBox(height: 16),
          GcText(
            text: 'Sides:',
            textStyleEnum: GcTextStyleEnum.bold,
            textSize: GcTextSizeEnum.h4,
            color: AppColors.black,
            gcStyles: GcStyles.poppins,
          ),
          const SizedBox(height: 4),
          GcText(
            text:
                'Flat Breads/Naans/Pita Bread/Multi Grain and White Bread in all shapes, displayed in bread basket.',
            textStyleEnum: GcTextStyleEnum.regular,
            textSize: GcTextSizeEnum.callout,
            color: AppColors.black,
            gcStyles: GcStyles.poppins,
          ),
          const SizedBox(height: 16),
          GcText(
            text: 'Condiments:',
            textStyleEnum: GcTextStyleEnum.bold,
            textSize: GcTextSizeEnum.h4,
            color: AppColors.black,
            gcStyles: GcStyles.poppins,
          ),
          const SizedBox(height: 4),
          GcText(
            text: '• Butter pats or whipped spread available • Hot sauce(s)\n'
                '• Salt and Pepper\n'
                '• Olive Oil Cruets\n'
                '• Packets of different salad dressings',
            textStyleEnum: GcTextStyleEnum.regular,
            textSize: GcTextSizeEnum.callout,
            color: AppColors.black,
            gcStyles: GcStyles.poppins,
          ),
          const SizedBox(height: 16),
          GcText(
            text: 'Beverages:',
            textStyleEnum: GcTextStyleEnum.bold,
            textSize: GcTextSizeEnum.h4,
            color: AppColors.black,
            gcStyles: GcStyles.poppins,
          ),
          const SizedBox(height: 4),
          GcText(
            text: 'One (1) bottle of water per guest',
            textStyleEnum: GcTextStyleEnum.regular,
            textSize: GcTextSizeEnum.callout,
            color: AppColors.black,
            gcStyles: GcStyles.poppins,
          ),
          const SizedBox(height: 16),
          GcText(
            text: 'Dessert:',
            textStyleEnum: GcTextStyleEnum.bold,
            textSize: GcTextSizeEnum.h4,
            color: AppColors.black,
            gcStyles: GcStyles.poppins,
          ),
          const SizedBox(height: 4),
          GcText(
            text: 'Assorted fruit, yogurts',
            textStyleEnum: GcTextStyleEnum.regular,
            textSize: GcTextSizeEnum.callout,
            color: AppColors.black,
            gcStyles: GcStyles.poppins,
          ),
        ],
      ),
    );
  }
}
