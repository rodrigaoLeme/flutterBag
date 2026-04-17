import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';
import '../section_view_model.dart';

// ignore: must_be_immutable
class ActionsCell extends StatelessWidget {
  final SectionType type;
  double width;
  final void Function(SectionType) onTap;

  ActionsCell({
    super.key,
    required this.type,
    this.width = 150,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(type);
      },
      child: Container(
        height: 128,
        width: width,
        decoration: BoxDecoration(
          color: type.colorForSection,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Container(
                height: 48,
                width: 48,
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    type.getImageForSection(isFolder: true),
                    color: type.colorForSection,
                    width: 24,
                    height: 24,
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: GcText(
                text: type.getTitleForSection(isFolder: true),
                textSize: GcTextSizeEnum.callout,
                textStyleEnum: GcTextStyleEnum.semibold,
                gcStyles: GcStyles.poppins,
                color: AppColors.white,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
