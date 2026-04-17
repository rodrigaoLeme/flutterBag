import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/cached_image.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';
import '../news_view_model.dart';

class NewsCell extends StatelessWidget {
  final NewsViewModel viewModel;
  final Function(NewsViewModel) onTap;

  const NewsCell({
    super.key,
    required this.viewModel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => onTap(viewModel),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: SizedBox(
                      height: 160,
                      child: CachedImageWidget(
                        imageUrl: viewModel.details?.coverPhotoUrl,
                        errorWidget: Image.asset(
                          'lib/ui/assets/images/news_image.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                GcText(
                  text: viewModel.details?.title ?? '',
                  textStyleEnum: GcTextStyleEnum.semibold,
                  textSize: GcTextSizeEnum.h3,
                  color: AppColors.black,
                  gcStyles: GcStyles.poppins,
                ),
                GcText(
                  text: viewModel.details?.lead ?? '',
                  textStyleEnum: GcTextStyleEnum.regular,
                  textSize: GcTextSizeEnum.subheadline,
                  color: AppColors.black,
                  gcStyles: GcStyles.poppins,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: GcText(
                  text: viewModel.details?.date ?? '',
                  textStyleEnum: GcTextStyleEnum.regular,
                  textSize: GcTextSizeEnum.caption1,
                  color: AppColors.black,
                  gcStyles: GcStyles.poppins,
                ),
              ),
              IconButton(
                icon: SvgPicture.asset(
                  'lib/ui/assets/images/icon/share-nodes-regular.svg',
                  height: 18.0,
                  width: 18.0,
                  color: AppColors.primaryLight,
                ),
                onPressed: () {
                  Share.share(viewModel.details?.link ?? '');
                },
              )
            ],
          ),
        ),
        const Divider(
          color: AppColors.neutralHighMedium,
          height: 1,
        ),
        const SizedBox(
          height: 16,
        )
      ],
    );
  }
}
