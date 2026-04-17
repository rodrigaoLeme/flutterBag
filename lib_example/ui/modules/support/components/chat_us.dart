import 'package:flutter/material.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';

class ChatUs extends StatelessWidget {
  const ChatUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          child: Container(
            height: 72.0,
            decoration: BoxDecoration(
              color: AppColors.neutralLight,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: GcText(
                    text: 'Chat with us',
                    textStyleEnum: GcTextStyleEnum.regular,
                    textSize: GcTextSizeEnum.callout,
                    color: AppColors.primaryLight,
                    gcStyles: GcStyles.poppins,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Icon(
                    Icons.send,
                    color: AppColors.primaryLight,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
