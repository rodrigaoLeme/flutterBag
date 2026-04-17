import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../main/routes/routes_app.dart';
import '../../../../share/utils/app_color.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';
import '../../agenda/agenda_view_model.dart';

class BusinessEventCard extends StatelessWidget {
  final ScheduleViewModel? viewModel;

  const BusinessEventCard({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Modular.to.pushNamed(
          Routes.eventDetails,
          arguments: viewModel,
        );
      },
      child: Card(
        color: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(
            color: AppColors.neutralHighMedium,
            width: 1.0,
          ),
        ),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GcText(
                      text: viewModel?.headerTitle ?? '',
                      textStyleEnum: GcTextStyleEnum.regular,
                      textSize: GcTextSizeEnum.footnote,
                      color: AppColors.primaryContainer,
                      gcStyles: GcStyles.poppins,
                    ),
                    const SizedBox(height: 4),
                    GcText(
                      text: viewModel?.name ?? '',
                      textStyleEnum: GcTextStyleEnum.regular,
                      textSize: GcTextSizeEnum.body,
                      color: AppColors.primaryContainer,
                      gcStyles: GcStyles.poppins,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'lib/ui/assets/images/icon/location-dot-light.svg',
                          height: 13,
                          width: 13,
                          fit: BoxFit.fill,
                          color: AppColors.neutralLowDark,
                        ),
                        const SizedBox(width: 4),
                        GcText(
                          text: viewModel?.location ?? '',
                          textStyleEnum: GcTextStyleEnum.regular,
                          textSize: GcTextSizeEnum.footnote,
                          color: AppColors.primaryContainer,
                          gcStyles: GcStyles.poppins,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.neutralLight,
                    ),
                    child: IconButton(
                      icon: SvgPicture.asset(
                        'lib/ui/assets/images/icon/star-light.svg',
                        color: AppColors.primaryLight,
                        width: 18,
                        height: 18,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
