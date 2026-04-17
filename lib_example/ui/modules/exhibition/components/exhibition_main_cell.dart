import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/cached_image.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';
import '../../modules.dart';
import 'favorites_exhibitions_bottom_sheet.dart';

// ignore: must_be_immutable
class ExhibitionMainCell extends StatefulWidget {
  final ExhibitionViewModel viewModel;
  final Future<ExhibitionViewModel> Function(ExhibitionViewModel)
      onFavoriteToggle;
  final Function(FilesViewModel?) onTapDownload;

  const ExhibitionMainCell({
    super.key,
    required this.viewModel,
    required this.onFavoriteToggle,
    required this.onTapDownload,
  });

  @override
  State<ExhibitionMainCell> createState() => ExhibitionMainCellState();
}

class ExhibitionMainCellState extends State<ExhibitionMainCell> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) => FavoritesExhibitionsBottomSheet(
            viewModel: widget.viewModel,
            onFavoriteToggle: widget.onFavoriteToggle,
            onTapDownload: widget.onTapDownload,
          ),
        );
      },
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: AppColors.neutralHighMedium,
            width: 1.0,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
              child: SizedBox(
                height: 100,
                width: 88,
                child: CachedImageWidget(
                  imageUrl: widget.viewModel.exhibitorPictureUrl,
                  fit: BoxFit.cover,
                  errorWidget: Image.asset(
                    'lib/ui/assets/images/image_default.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 8,
                  left: 12,
                  bottom: 6,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: GcText(
                        text: widget.viewModel.name ?? '',
                        gcStyles: GcStyles.poppins,
                        textSize: GcTextSizeEnum.h4w500,
                        textStyleEnum: GcTextStyleEnum.regular,
                        color: AppColors.primaryLight,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    if (widget.viewModel.description?.isNotEmpty == true)
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 16,
                          bottom: 4,
                          top: 4,
                        ),
                        child: GcText(
                          text: widget.viewModel.description ?? '',
                          gcStyles: GcStyles.poppins,
                          textSize: GcTextSizeEnum.subheadline,
                          textStyleEnum: GcTextStyleEnum.regular,
                          color: AppColors.neutralLowDark,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    SizedBox(
                      height: 30,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (widget.viewModel.location != null &&
                              widget.viewModel.location != '')
                            SizedBox(
                              height: 13,
                              width: 13,
                              child: SvgPicture.asset(
                                'lib/ui/assets/images/icon/location-dot-light.svg',
                                height: 13,
                                width: 13,
                                fit: BoxFit.contain,
                                color: AppColors.neutralLowDark,
                              ),
                            ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: GcText(
                                text: widget.viewModel.location ?? '',
                                gcStyles: GcStyles.poppins,
                                textSize: GcTextSizeEnum.footnote,
                                textStyleEnum: GcTextStyleEnum.regular,
                                color: AppColors.neutralLowDark,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: SvgPicture.asset(
                              widget.viewModel.isFavorite == true
                                  ? 'lib/ui/assets/images/icon/heart-solid.svg'
                                  : 'lib/ui/assets/images/icon/heart-light.svg',
                              color: AppColors.primaryLight,
                              fit: BoxFit.contain,
                              width: 16,
                              height: 16,
                            ),
                            onPressed: () {
                              widget.onFavoriteToggle(widget.viewModel);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
