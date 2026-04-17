import 'package:flutter/material.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';
import '../../modules.dart';

class FaqInformationCell extends StatelessWidget {
  final SupportResultViewModel viewModel;
  final Function(SupportResultViewModel) onTap;

  const FaqInformationCell({
    super.key,
    required this.viewModel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: GestureDetector(
            onTap: () => onTap(viewModel),
            child: Container(
              width: double.infinity,
              height: 84.0,
              decoration: BoxDecoration(
                color: AppColors.neutralLight,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GcText(
                    text: viewModel.title ?? '',
                    textStyleEnum: GcTextStyleEnum.regular,
                    textSize: GcTextSizeEnum.body,
                    color: AppColors.primaryLight,
                    gcStyles: GcStyles.poppins,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
