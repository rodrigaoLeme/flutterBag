import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';
import '../../dashboard/section_view_model.dart';

class MenuItemCell extends StatelessWidget {
  final SectionType type;
  final void Function(SectionType) onTap;

  const MenuItemCell({
    Key? key,
    required this.type,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(type);
      },
      child: Container(
        height: 82,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.neutralLight,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  type.getImageForSection(isFolder: false),
                  height: 20,
                  width: 20,
                  color: AppColors.primaryLight,
                ),
                const SizedBox(width: 16.0),
                GcText(
                  text: type.getTitleForSection(isFolder: false),
                  gcStyles: GcStyles.poppins,
                  textSize: GcTextSizeEnum.body,
                  textStyleEnum: GcTextStyleEnum.regular,
                  color: AppColors.primaryLight,
                ),
              ],
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.primaryLight,
            ),
          ],
        ),
      ),
    );
  }
}
