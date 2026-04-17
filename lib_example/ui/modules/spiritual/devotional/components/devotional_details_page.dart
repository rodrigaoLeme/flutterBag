import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../share/utils/app_color.dart';
import '../../../../components/empty_state.dart';
import '../../../../components/enum/design_system_enums.dart';
import '../../../../components/gc_text.dart';
import '../../../../components/themes/gc_styles.dart';
import '../../../../components/youtube_player_web_view.dart';
import '../../../../helpers/i18n/resources.dart';
import '../../../food/components/filter_costum.dart';
import '../../spiritual_view_model.dart';
import 'devotional_speaker_section.dart';

class DevotionalDetailsPage extends StatefulWidget {
  final DevotionalTabViewModel? viewModel;
  final Function(DevotionalFilter?) onTap;
  final Function(DevotionalLanguages?) onTapLanguage;

  const DevotionalDetailsPage({
    required this.viewModel,
    required this.onTap,
    required this.onTapLanguage,
    super.key,
  });

  @override
  DevotionalDetailsPageState createState() => DevotionalDetailsPageState();
}

class DevotionalDetailsPageState extends State<DevotionalDetailsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.viewModel == null ||
        widget.viewModel?.shouldShowEmptyState == true) {
      return Scaffold(
        backgroundColor: AppColors.white,
        body: EmptyState(
          icon: 'lib/ui/assets/images/icon/book-open-cover.svg',
          title: R.string.messageEmpty,
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 56,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.viewModel?.filters.length ?? 0,
              itemBuilder: (context, index) {
                final item = widget.viewModel?.filters[index];
                final isSelected =
                    item?.date == widget.viewModel?.currentFilter?.date;
                return GestureDetector(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 16),
                    child: FilterCostum(
                      text: item?.filterDate.toUpperCase() ?? '',
                      onTap: () {
                        widget.onTap(item);
                      },
                      backgroundColor: isSelected
                          ? AppColors.primaryLight
                          : AppColors.neutralLight,
                      textColor: isSelected
                          ? AppColors.neutralLight
                          : AppColors.primaryLight,
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 24.0, bottom: 16.0, left: 16.0, right: 16.0),
            child: GcText(
              text: widget.viewModel?.currentItem?.title ?? '',
              textSize: GcTextSizeEnum.h3,
              textStyleEnum: GcTextStyleEnum.bold,
              color: AppColors.neutralLowDark,
              gcStyles: GcStyles.poppins,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          if (widget.viewModel?.currentItem?.linkByLanguage?.link != null)
            Builder(builder: (context) {
              final url =
                  widget.viewModel?.currentItem?.linkByLanguage?.link ?? '';

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 194,
                          child: YoutubeWebViewPlayer(
                            key: ValueKey(url),
                            youtubeUrl: url,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          DevotionalSpeakerSection(
              viewModel: widget.viewModel?.currentItem?.speakers ?? []),
          const SizedBox(height: 14),
          Expanded(
            child: ListView.builder(
              itemCount: widget.viewModel?.currentItem?.languages.length ?? 0,
              itemBuilder: (context, index) {
                final item = widget.viewModel?.currentItem?.languages[index];
                final isSelected = item?.language ==
                    widget.viewModel?.currentItem?.currentLanguageFilter
                        ?.language;
                return GestureDetector(
                  onTap: () {
                    widget.onTapLanguage(item);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16.0, bottom: 8.0),
                    child: Container(
                      height: 82,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryLight
                            : AppColors.neutralLight,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GcText(
                            text: item?.language ?? '',
                            gcStyles: GcStyles.poppins,
                            textSize: GcTextSizeEnum.body,
                            textStyleEnum: GcTextStyleEnum.regular,
                            color: isSelected
                                ? AppColors.white
                                : AppColors.primaryLight,
                          ),
                          const SizedBox(width: 12),
                          SvgPicture.asset(
                            'lib/ui/assets/images/icon/play-solid.svg',
                            height: 20,
                            width: 20,
                            color: isSelected
                                ? AppColors.white
                                : AppColors.primaryLight,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
