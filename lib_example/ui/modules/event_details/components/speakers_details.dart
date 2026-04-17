import 'package:flutter/material.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/cached_image.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';
import '../../../helpers/extensions/string_extension.dart';
import '../../../helpers/i18n/resources.dart';
import '../../exhibition/components/card_social_media_section.dart';
import '../event_details_view_model.dart';

class SpeakersDetails extends StatefulWidget {
  final SpeakersViewModel? viewModel;
  final ScrollController? scrollController;

  const SpeakersDetails({
    super.key,
    required this.viewModel,
    this.scrollController,
  });

  @override
  SpeakersDetailsState createState() => SpeakersDetailsState();
}

class SpeakersDetailsState extends State<SpeakersDetails> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      controller: widget.scrollController,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16.0),
          ),
        ),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: double.infinity,
                  height: 120,
                  color: widget.viewModel?.photoBackgroundColor?.toColor(),
                ),
                Positioned(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 100,
                          height: 3,
                          decoration: BoxDecoration(
                            color: AppColors.neutralHigh,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 60,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.white,
                          width: 1.5,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: CachedImageWidget(
                          imageUrl: widget.viewModel?.photoUrl ?? '',
                          fit: BoxFit.cover,
                          errorWidget: Container(
                            color: AppColors.neutralHighMedium,
                            child: Center(
                              child: GcText(
                                text: widget.viewModel?.personInitial ?? '',
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
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, top: 48.0, bottom: 8.0),
                  child: GcText(
                    text: widget.viewModel?.fullName ?? '',
                    textStyleEnum: GcTextStyleEnum.bold,
                    textSize: GcTextSizeEnum.h2,
                    color: AppColors.black,
                    gcStyles: GcStyles.poppins,
                  ),
                ),
                const SizedBox(height: 4.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GcText(
                    text: widget.viewModel?.division ?? '',
                    textStyleEnum: GcTextStyleEnum.regular,
                    textSize: GcTextSizeEnum.callout,
                    color: AppColors.neutralLowDark,
                    gcStyles: GcStyles.poppins,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GcText(
                    text: widget.viewModel?.jobTitle ?? '',
                    textStyleEnum: GcTextStyleEnum.regular,
                    textSize: GcTextSizeEnum.callout,
                    color: AppColors.neutralLowDark,
                    gcStyles: GcStyles.poppins,
                  ),
                ),
                const SizedBox(height: 20.0),
                const Divider(
                  color: AppColors.neutralHighMedium,
                  height: 1,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.viewModel?.biography?.isNotEmpty == true)
                        GcText(
                          text: R.string.biographyLabel,
                          textStyleEnum: GcTextStyleEnum.bold,
                          textSize: GcTextSizeEnum.h3,
                          color: AppColors.black,
                          gcStyles: GcStyles.poppins,
                        ),
                      if (widget.viewModel?.biography?.isNotEmpty == true)
                        const SizedBox(height: 8.0),
                      if (widget.viewModel?.biography?.isNotEmpty == true)
                        GcText(
                          text: widget.viewModel?.biography ?? '',
                          textStyleEnum: GcTextStyleEnum.regular,
                          textSize: GcTextSizeEnum.subheadline,
                          color: AppColors.neutralLowDark,
                          gcStyles: GcStyles.poppins,
                        ),
                      if (widget.viewModel?.social?.isNotEmpty == true)
                        Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: GcText(
                            text: R.string.socialMediaLabel,
                            textStyleEnum: GcTextStyleEnum.bold,
                            textSize: GcTextSizeEnum.h3,
                            color: AppColors.black,
                            gcStyles: GcStyles.poppins,
                          ),
                        ),
                      for (var item in widget.viewModel?.social ?? [])
                        if (item.isNotEmpty == true)
                          CardSocialMediaSection(
                            url: item as String,
                          ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
