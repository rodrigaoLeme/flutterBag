import 'package:flutter/material.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';
import '../../../helpers/helpers.dart';
import '../exhibition_view_model.dart';
import 'card_social_media_section.dart';

class ResourcesFavoritesExhibitions extends StatelessWidget {
  final ExhibitionViewModel viewModel;

  const ResourcesFavoritesExhibitions({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding:
            const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 32, top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (viewModel.description?.isNotEmpty == true)
              GcText(
                text: R.string.descriptionLabel,
                textStyleEnum: GcTextStyleEnum.bold,
                textSize: GcTextSizeEnum.h3,
                color: AppColors.black,
                gcStyles: GcStyles.poppins,
              ),
            if (viewModel.description?.isNotEmpty == true)
              const SizedBox(height: 8.0),
            if (viewModel.description?.isNotEmpty == true)
              GcText(
                text: viewModel.description ?? '',
                textStyleEnum: GcTextStyleEnum.regular,
                textSize: GcTextSizeEnum.subheadline,
                color: AppColors.neutralLowDark,
                gcStyles: GcStyles.poppins,
              ),
            if (viewModel.social?.isNotEmpty == true)
              Padding(
                padding: const EdgeInsets.only(top: 32.0, bottom: 8.0),
                child: GcText(
                  text: R.string.socialMediaLabel,
                  textStyleEnum: GcTextStyleEnum.bold,
                  textSize: GcTextSizeEnum.h3,
                  color: AppColors.black,
                  gcStyles: GcStyles.poppins,
                ),
              ),
            for (var item in viewModel.social ?? [])
              if (item.isNotEmpty == true)
                CardSocialMediaSection(
                  url: item as String,
                ),
          ],
        ),
      ),
    );
  }
}
