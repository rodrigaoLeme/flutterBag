import 'package:flutter/material.dart';

import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';

class VotingResultUserCell extends StatelessWidget {
  final String image;
  final String position;
  const VotingResultUserCell(
      {super.key, required this.image, required this.position});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipOval(
          child: Image.asset(
            height: 88,
            width: 88,
            image,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 8),
        GcText(
          text: position,
          textSize: GcTextSizeEnum.subheadline,
          textStyleEnum: GcTextStyleEnum.regular,
          gcStyles: GcStyles.poppins,
        ),
      ],
    );
  }
}
