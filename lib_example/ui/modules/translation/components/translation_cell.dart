import 'package:flutter/material.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';
import '../translation_view_model.dart';

class TranslationCell extends StatelessWidget {
  final Languages? language;
  final void Function(Languages?) onTap;
  final bool isSelected;

  const TranslationCell({
    Key? key,
    required this.language,
    required this.onTap,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(language);
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppColors.neutralHigh),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipOval(
              child: Image.asset(
                language?.flag ?? '',
                width: 24,
                height: 24,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GcText(
                text: language?.contryName ?? '',
                gcStyles: GcStyles.poppins,
                textSize: GcTextSizeEnum.callout,
                textStyleEnum: GcTextStyleEnum.regular,
                color: AppColors.neutralLowDark,
              ),
            ),
            if (isSelected)
              const SizedBox(
                width: 24,
                height: 24,
                child: Icon(
                  Icons.check,
                ),
              )
          ],
        ),
      ),
    );
  }
}
