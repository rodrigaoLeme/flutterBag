import 'package:flutter/material.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/cached_image.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';
import '../../news/news_view_model.dart';

class InformationCell extends StatelessWidget {
  final NewsViewModel viewModel;

  const InformationCell({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 138,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: SizedBox(
              height: 166,
              child: CachedImageWidget(
                imageUrl: viewModel.details?.homePhotoUrl,
                errorWidget: Image.asset(
                  'lib/ui/assets/images/news_image.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: GcText(
              text: viewModel.details?.title ?? '',
              textSize: GcTextSizeEnum.subhead,
              textStyleEnum: GcTextStyleEnum.regular,
              gcStyles: GcStyles.poppins,
              color: AppColors.neutralLowDark,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }
}
