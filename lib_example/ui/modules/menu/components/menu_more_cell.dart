import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';
import '../../dashboard/section_view_model.dart';

class MenuMoreCell extends StatelessWidget {
  final SectionViewModel? viewModel;

  const MenuMoreCell({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        color: AppColors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  height: 40.0,
                  width: 40.0,
                  child: SvgPicture.asset(
                    viewModel?.sectionTypeFromMenu?.icon ?? '',
                    height: 40.0,
                    width: 40.0,
                    fit: BoxFit.scaleDown,
                    color: AppColors.primaryLight,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                GcText(
                  text: viewModel?.name ?? '',
                  textStyleEnum: GcTextStyleEnum.regular,
                  textSize: GcTextSizeEnum.body,
                  color: AppColors.primaryLight,
                  gcStyles: GcStyles.poppins,
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            const Divider(
              color: AppColors.neutralHighMedium,
              thickness: 0.8,
            ),
          ],
        ),
      ),
    );
  }
}
