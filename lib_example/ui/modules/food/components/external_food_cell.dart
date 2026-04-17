import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/cached_image.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';
import '../food_view_model.dart';

class ExternalFoodCell extends StatelessWidget {
  final ExternalFoodViewModel viewModel;
  final void Function(ExternalFoodViewModel) onFavoriteToggle;

  const ExternalFoodCell({
    super.key,
    required this.viewModel,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(
          color: AppColors.neutralHighMedium,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipOval(
              child: SizedBox(
                height: 102,
                width: 102,
                child: CachedImageWidget(
                  imageUrl: viewModel.photoUrl ?? '',
                  fit: BoxFit.fill,
                  errorWidget: Image.asset(
                    'lib/ui/assets/images/image_default.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (viewModel.isSponsor ?? false) ...[
                        SvgPicture.asset(
                          'lib/ui/assets/images/icon/circle-star-regular.svg',
                          height: 16,
                          width: 16,
                          fit: BoxFit.fill,
                          color: AppColors.sunFlower,
                        ),
                        const SizedBox(width: 6),
                      ],
                      Expanded(
                        child: GcText(
                          text: viewModel.name ?? '',
                          textStyleEnum: GcTextStyleEnum.semibold,
                          textSize: GcTextSizeEnum.callout,
                          color: AppColors.neutralLowDark,
                          gcStyles: GcStyles.poppins,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (viewModel.discount?.isNotEmpty == true)
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: GcText(
                        text: viewModel.discount ?? '',
                        textStyleEnum: GcTextStyleEnum.regular,
                        textSize: GcTextSizeEnum.caption1,
                        color: AppColors.primaryLight,
                        gcStyles: GcStyles.poppins,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'lib/ui/assets/images/icon/location-dot-light.svg',
                        height: 13,
                        width: 13,
                        fit: BoxFit.fill,
                        color: AppColors.neutralLowDark,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: GcText(
                          text: viewModel.location ?? '',
                          textStyleEnum: GcTextStyleEnum.regular,
                          textSize: GcTextSizeEnum.caption1,
                          color: AppColors.neutralLowDark,
                          gcStyles: GcStyles.poppins,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SvgPicture.asset(
                              'lib/ui/assets/images/icon/hat-chef-light.svg',
                              height: 13,
                              width: 13,
                              fit: BoxFit.fill,
                              color: AppColors.neutralLowDark,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: GcText(
                                text: viewModel.typeCuisine ?? '',
                                textStyleEnum: GcTextStyleEnum.regular,
                                textSize: GcTextSizeEnum.caption1,
                                color: AppColors.neutralLowDark,
                                gcStyles: GcStyles.poppins,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 38,
                        child: IconButton(
                          onPressed: () {
                            onFavoriteToggle(viewModel);
                          },
                          icon: Icon(
                            viewModel.isFavorite == false
                                ? Icons.favorite_border_outlined
                                : Icons.favorite,
                            color: AppColors.primaryLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
