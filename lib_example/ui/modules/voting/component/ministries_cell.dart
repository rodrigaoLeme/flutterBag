import 'package:flutter/material.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';
import '../../modules.dart';

// ignore: must_be_immutable
class MinistriesCell extends StatelessWidget {
  final DivisionGroup? viewModel;
  final void Function(DivisionGroup?) onChanged;

  const MinistriesCell({
    super.key,
    required this.viewModel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(viewModel);
      },
      child: Container(
        alignment: Alignment.center,
        height: 60,
        decoration: BoxDecoration(
          color: viewModel?.isSelected == true
              ? AppColors.primaryLight
              : AppColors.cardLigth,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(8),
        child: GcText(
          text: viewModel?.divisionAcronym ?? '',
          textStyleEnum: GcTextStyleEnum.bold,
          textSize: GcTextSizeEnum.callout,
          color: viewModel?.isSelected == true
              ? AppColors.white
              : AppColors.primaryLight,
          gcStyles: GcStyles.poppins,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
