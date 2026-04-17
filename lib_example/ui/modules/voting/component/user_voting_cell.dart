import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';
import '../voting_view_model.dart';

class UserVotingCell extends StatelessWidget {
  final VotingViewModel? viewModel;

  const UserVotingCell({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 102,
      height: 174,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                padding: const EdgeInsets.all(4.0),
                width: 102,
                height: 102,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primaryLight,
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: viewModel?.photoUrl ?? '',
                    fit: BoxFit.cover,
                    errorWidget: (context, error, stackTrace) {
                      return Container(
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
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: GcText(
                    text: viewModel?.divisionAcronym ?? '',
                    textStyleEnum: GcTextStyleEnum.bold,
                    textSize: GcTextSizeEnum.caption1,
                    color: AppColors.white,
                    gcStyles: GcStyles.poppins,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          GcText(
            text: viewModel?.personName ?? '',
            textStyleEnum: GcTextStyleEnum.bold,
            textSize: GcTextSizeEnum.subheadline,
            color: AppColors.black,
            gcStyles: GcStyles.poppins,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          GcText(
            text: viewModel?.positionName ?? '',
            textStyleEnum: GcTextStyleEnum.regular,
            textSize: GcTextSizeEnum.caption2,
            color: AppColors.neutralLowMedium,
            gcStyles: GcStyles.poppins,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
