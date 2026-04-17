import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';
import '../documents_view_model.dart';

class DocumentsCell extends StatelessWidget {
  final DocumentsResultViewModel viewModel;
  final Function(DocumentsResultViewModel) onTap;

  const DocumentsCell({
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
              height: 72.0,
              decoration: BoxDecoration(
                color: AppColors.neutralLight,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // if (viewModel.documentsTypeModel.toString() !=
                    //     DocumentsTypeModel.text.toString())
                    SvgPicture.asset(
                      viewModel.docIcon,
                      color: AppColors.primaryLight,
                      width: 18,
                      height: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GcText(
                        text: viewModel.name ?? '',
                        textStyleEnum: GcTextStyleEnum.regular,
                        textSize: GcTextSizeEnum.body,
                        color: AppColors.primaryLight,
                        gcStyles: GcStyles.poppins,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
