import 'package:flutter/material.dart';

import '../../../../../share/utils/app_color.dart';
import '../../../../components/cached_image.dart';
import '../../../../components/enum/design_system_enums.dart';
import '../../../../components/gc_text.dart';
import '../../../../components/themes/gc_styles.dart';
import '../../music_view_model.dart';

class PreviewVideoWidget extends StatelessWidget {
  final MusicViewModel? viewModel;
  final void Function(MusicViewModel?) onTap;

  const PreviewVideoWidget({
    Key? key,
    required this.viewModel,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Column(
        children: [
          Container(
            height: 108,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    onTap(viewModel);
                  },
                  child: Container(
                    // width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8.0)),
                          child: SizedBox(
                            width: 150,
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8.0)),
                              child: CachedImageWidget(
                                imageUrl: viewModel?.thumbnailUrl ?? '',
                                fit: BoxFit.cover,
                                errorWidget: Image.asset(
                                  'lib/ui/assets/images/image_default.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: SizedBox(
                            width: 176,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GcText(
                                  text: viewModel?.name ?? '',
                                  textSize: GcTextSizeEnum.body,
                                  textStyleEnum: GcTextStyleEnum.regular,
                                  gcStyles: GcStyles.poppins,
                                  color: AppColors.neutralLowDark,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: AppColors.neutralLight,
            height: 1,
          )
        ],
      ),
    );
  }
}
