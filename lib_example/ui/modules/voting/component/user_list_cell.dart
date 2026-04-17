import 'package:flutter/material.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/cached_image.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';
import '../../modules.dart';

class UserListCell extends StatelessWidget {
  final VotingViewModel? viewModel;

  const UserListCell({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6.0, left: 10.0, right: 16.0),
      child: GestureDetector(
        onTap: () {},
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4.0),
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: CachedImageWidget(
                  imageUrl: viewModel?.photoUrl ?? '',
                  fit: BoxFit.cover,
                  errorWidget: Container(
                    color: AppColors.neutralHighMedium,
                    child: Center(
                      child: GcText(
                        text: viewModel?.personInitial ?? '',
                        textStyleEnum: GcTextStyleEnum.bold,
                        textSize: GcTextSizeEnum.h3,
                        color: AppColors.primaryLight,
                        gcStyles: GcStyles.poppins,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GcText(
                    text: viewModel?.personName ?? '',
                    textStyleEnum: GcTextStyleEnum.bold,
                    textSize: GcTextSizeEnum.callout,
                    color: AppColors.neutralLowDark,
                    gcStyles: GcStyles.poppins,
                    textAlign: TextAlign.left,
                  ),
                  GcText(
                    text: viewModel?.positionName ?? '',
                    textStyleEnum: GcTextStyleEnum.regular,
                    textSize: GcTextSizeEnum.subheadline,
                    color: AppColors.neutralLowMedium,
                    gcStyles: GcStyles.poppins,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
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
