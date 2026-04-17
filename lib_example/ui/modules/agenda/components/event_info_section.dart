import 'package:flutter/material.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';
import '../../modules.dart';

class EventInfoSection extends StatelessWidget {
  const EventInfoSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 24.0),
          child: GcText(
            text: 'Today, July 8',
            textSize: GcTextSizeEnum.h3,
            textStyleEnum: GcTextStyleEnum.bold,
            gcStyles: GcStyles.poppins,
            color: AppColors.black,
          ),
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return const Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: EventInfoCell(),
              );
            },
            itemCount: 8,
          ),
        ),
      ],
    );
  }
}
