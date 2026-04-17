import 'package:flutter/material.dart';

import '../../../../share/utils/app_color.dart';
import '../../components/enum/design_system_enums.dart';
import '../../components/gc_text.dart';
import '../../components/themes/gc_styles.dart';
import 'voting_view_model.dart';

class VotingDetailsCell extends StatelessWidget {
  final VotingViewModel? viewModel;
  final VoidCallback? onClose;

  const VotingDetailsCell({
    Key? key,
    required this.viewModel,
    this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryLight,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 182,
                    height: 182,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.white,
                        width: 1.5,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.network(
                        viewModel?.photoUrl ?? '',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
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
                  const SizedBox(height: 24),
                  GcText(
                    text: viewModel?.personName ?? '',
                    textStyleEnum: GcTextStyleEnum.bold,
                    textSize: GcTextSizeEnum.h28,
                    color: AppColors.white,
                    gcStyles: GcStyles.poppins,
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 16.0),
                    child: GcText(
                      text: viewModel?.positionName ?? '',
                      textStyleEnum: GcTextStyleEnum.regular,
                      textSize: GcTextSizeEnum.callout,
                      color: AppColors.white,
                      gcStyles: GcStyles.poppins,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  GcText(
                    text: viewModel?.divisionAcronym ?? '',
                    textStyleEnum: GcTextStyleEnum.regular,
                    textSize: GcTextSizeEnum.callout,
                    color: AppColors.white,
                    gcStyles: GcStyles.poppins,
                    textAlign: TextAlign.center,
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
