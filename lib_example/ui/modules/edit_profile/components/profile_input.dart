import 'package:flutter/material.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';

class ProfileInput extends StatelessWidget {
  final String title;

  const ProfileInput({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 12.0),
          child: GcText(
            text: title,
            textSize: GcTextSizeEnum.callout,
            textStyleEnum: GcTextStyleEnum.regular,
            color: AppColors.black,
            gcStyles: GcStyles.poppins,
          ),
        ),
        Container(
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: AppColors.white,
            border: Border.all(color: AppColors.secundaryContainer),
          ),
          child: TextFormField(
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).disabledColor),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
            ),
            keyboardType: TextInputType.name,
          ),
        ),
      ],
    );
  }
}
