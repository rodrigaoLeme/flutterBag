import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../share/utils/app_color.dart';
import '../../../../components/cached_image.dart';
import '../../../../components/enum/design_system_enums.dart';
import '../../../../components/gc_text.dart';
import '../../../../components/themes/gc_styles.dart';
import '../../../../helpers/responsive/responsive.dart';
import '../../../event_details/components/speakers_details.dart';
import '../../../event_details/event_details_view_model.dart';

class DevotionalSpeakerSection extends StatelessWidget {
  final List<SpeakersViewModel> viewModel;

  const DevotionalSpeakerSection({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    if (viewModel.isEmpty) return const SizedBox.shrink();
    final speakers = viewModel;
    return Container(
      padding: const EdgeInsets.only(top: 16),
      height: 90,
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
                          initialChildSize: speakers[index].minBottomSheetSize,
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
                    width: ResponsiveLayout.of(context).wp(80),
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: index == speakers.length - 1 ? 0 : 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipOval(
                            child: SizedBox(
                              height: 62,
                              width: 62,
                              child: CachedImageWidget(
                                imageUrl: speakers[index].photoUrl ?? '',
                                fit: BoxFit.cover,
                                errorWidget: SvgPicture.asset(
                                  'lib/ui/assets/images/icon/circle-user-solid.svg',
                                  fit: BoxFit.cover,
                                  color: AppColors.neutralHigh,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: SizedBox(
                                height: 62,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GcText(
                                      text: speakers[index].fullName ?? '',
                                      textSize: GcTextSizeEnum.subheadline,
                                      textStyleEnum: GcTextStyleEnum.semibold,
                                      color: AppColors.black,
                                      gcStyles: GcStyles.poppins,
                                      textAlign: TextAlign.left,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    GcText(
                                      text: speakers[index].division ?? '',
                                      textSize: GcTextSizeEnum.footnote,
                                      textStyleEnum: GcTextStyleEnum.regular,
                                      color: AppColors.outline,
                                      gcStyles: GcStyles.poppins,
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
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
          ),
        ),
      ),
    );
  }
}
