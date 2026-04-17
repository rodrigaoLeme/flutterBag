import 'package:flutter/material.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/cached_image.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';
import '../../../helpers/i18n/resources.dart';
import '../event_details_view_model.dart';
import 'speakers_details.dart';

class TodaysSpeakersSection extends StatelessWidget {
  final List<SpeakersViewModel>? viewModel;

  const TodaysSpeakersSection({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    if (viewModel == null || viewModel!.isEmpty) return const SizedBox.shrink();
    final speakers = viewModel ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0, left: 16.0),
          child: GcText(
            text: R.string.participantsLabel,
            textSize: GcTextSizeEnum.h3,
            textStyleEnum: GcTextStyleEnum.bold,
            color: AppColors.black,
            gcStyles: GcStyles.poppins,
          ),
        ),
        SizedBox(
          height: 168,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int index = 0; index < speakers.length; index++)
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          backgroundColor: Colors.white,
                          context: context,
                          isScrollControlled: true,
                          enableDrag: true,
                          builder: (context) {
                            return DraggableScrollableSheet(
                              initialChildSize:
                                  speakers[index].minBottomSheetSize,
                              maxChildSize: 0.9,
                              minChildSize: 0.4,
                              expand: false,
                              builder: (_, controller) {
                                return SpeakersDetails(
                                  viewModel: speakers[index],
                                  scrollController: controller,
                                );
                              },
                            );
                          },
                        );
                      },
                      child: SizedBox(
                        width: 104,
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: index == speakers.length - 1 ? 0 : 10,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: SizedBox(
                                  height: 82,
                                  width: 82,
                                  child: CachedImageWidget(
                                    imageUrl: speakers[index].photoUrl ?? '',
                                    fit: BoxFit.cover,
                                    errorWidget: Container(
                                      color: AppColors.neutralHighMedium,
                                      child: Center(
                                        child: GcText(
                                          text: speakers[index].personInitial,
                                          textStyleEnum: GcTextStyleEnum.bold,
                                          textSize: GcTextSizeEnum.h3,
                                          color: AppColors.neutralLowMedium,
                                          gcStyles: GcStyles.poppins,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: GcText(
                                        text: speakers[index].fullName ?? '',
                                        textSize: GcTextSizeEnum.subheadline,
                                        textStyleEnum: GcTextStyleEnum.semibold,
                                        color: AppColors.black,
                                        gcStyles: GcStyles.poppins,
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    GcText(
                                      text: speakers[index].division ?? '',
                                      textSize: GcTextSizeEnum.caption1,
                                      textStyleEnum: GcTextStyleEnum.regular,
                                      color: AppColors.outline,
                                      gcStyles: GcStyles.poppins,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
