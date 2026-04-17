import 'package:flutter/material.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/cached_image.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';
import '../broadcast_view_model.dart';

class PreviousCell extends StatelessWidget {
  final BroadcastViewModel? viewModel;
  final Function(BroadcastViewModel?) onTap;

  const PreviousCell({
    Key? key,
    required this.viewModel,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 148,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                child: GestureDetector(
                  onTap: () {
                    onTap(viewModel);
                  },
                  child: SizedBox(
                    width: double.infinity,
                    height: 108,
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(4.0)),
                      child: CachedImageWidget(
                        imageUrl: viewModel?.thumbnailUrl ?? '',
                        fit: BoxFit.cover,
                        errorWidget: Image.asset(
                          'lib/ui/assets/images/image_default.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0, bottom: 8.0, right: 4.0),
            child: Row(
              children: [
                Expanded(
                  child: GcText(
                    text: viewModel?.language ?? '',
                    textSize: GcTextSizeEnum.caption1,
                    textStyleEnum: GcTextStyleEnum.regular,
                    gcStyles: GcStyles.poppins,
                    color: AppColors.neutralLowMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 7.0),
                  decoration: BoxDecoration(
                    color: viewModel?.isLiveColor ?? Colors.transparent,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: GcText(
                    text: viewModel?.isLiveLabel ?? '',
                    textSize: GcTextSizeEnum.caption1,
                    textStyleEnum: GcTextStyleEnum.bold,
                    color: AppColors.white,
                    gcStyles: GcStyles.poppins,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          GcText(
            text: viewModel?.formatedDate ?? '',
            textSize: GcTextSizeEnum.body,
            textStyleEnum: GcTextStyleEnum.regular,
            gcStyles: GcStyles.poppins,
            color: AppColors.neutralLowDark,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
