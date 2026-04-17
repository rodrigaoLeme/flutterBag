import 'package:flutter/material.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/cached_image.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';
import '../choose_event_view_model.dart';

class EventMainCell extends StatelessWidget {
  final EventViewModel? viewModel;
  const EventMainCell({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 112,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: AppColors.neutralHighMedium,
          width: 1.0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(
                Radius.circular(8.0),
              ),
              child: SizedBox(
                height: 96,
                width: 96,
                child: CachedImageWidget(
                  imageUrl: viewModel?.eventLogo ?? '',
                  fit: BoxFit.cover,
                  errorWidget: Image.asset(
                    'lib/ui/assets/images/image_default.png',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          // Conteúdo textual
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: GcText(
                      text: viewModel?.name ?? '',
                      gcStyles: GcStyles.poppins,
                      textSize: GcTextSizeEnum.h4,
                      textStyleEnum: GcTextStyleEnum.semibold,
                      color: AppColors.primaryLight,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    children: [
                      Image.asset(
                        'lib/ui/assets/images/icon/calendar.png',
                        color: AppColors.neutralLowDark,
                        height: 14,
                        width: 14,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: GcText(
                          text: viewModel?.dateWithHour ?? '',
                          gcStyles: GcStyles.poppins,
                          textSize: GcTextSizeEnum.footnote,
                          textStyleEnum: GcTextStyleEnum.regular,
                          color: AppColors.neutralLowDark,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0, top: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              'lib/ui/assets/images/icon/location_icon.png',
                              color: AppColors.neutralLowDark,
                              height: 14,
                              width: 14,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: GcText(
                                  text: viewModel?.address ?? '',
                                  gcStyles: GcStyles.poppins,
                                  textSize: GcTextSizeEnum.footnote,
                                  textStyleEnum: GcTextStyleEnum.regular,
                                  color: AppColors.neutralLowDark,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.favorite,
                          color: AppColors.primaryLight,
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
    );
  }
}
