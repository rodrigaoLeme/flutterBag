import 'package:flutter/material.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/cached_image.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';
import '../../exhibition/exhibition_view_model.dart';

class ExhibitionsCell extends StatelessWidget {
  final List<ExhibitionViewModel> exhibitions;
  final Function(ExhibitionViewModel) onTap;
  final double width;

  const ExhibitionsCell({
    super.key,
    required this.exhibitions,
    required this.onTap,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: exhibitions.length,
        itemBuilder: (context, index) {
          final exhibition = exhibitions[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: GestureDetector(
              onTap: () {
                onTap(exhibition);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: AppColors.neutralHighMedium,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                      ),
                      child: SizedBox(
                        width: 93,
                        height: 73,
                        child: CachedImageWidget(
                          imageUrl: exhibition.exhibitorPictureUrl ?? '',
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GcText(
                              text: exhibition.name ?? '',
                              textSize: GcTextSizeEnum.subheadlineW400,
                              textStyleEnum: GcTextStyleEnum.regular,
                              gcStyles: GcStyles.poppins,
                              color: AppColors.neutralLowDark,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8.0),
                            GcText(
                              text: exhibition.description ?? '',
                              textSize: GcTextSizeEnum.subheadline,
                              textStyleEnum: GcTextStyleEnum.regular,
                              gcStyles: GcStyles.poppins,
                              color: AppColors.neutralLowDark,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
