import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../presentation/presenters/navigation_bar/tab_bar_itens.dart';
import '../../../../share/utils/app_color.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';
import '../../navigation/navigation_bar_presenter.dart';
import '../exhibition_view_model.dart';

// ignore: must_be_immutable
class HeaderFavoritesExhibitions extends StatelessWidget {
  ExhibitionViewModel viewModel;
  final Future<ExhibitionViewModel> Function(ExhibitionViewModel)
      onFavoriteToggle;
  ValueNotifier<bool?> isfavorite = ValueNotifier(null);

  HeaderFavoritesExhibitions({
    super.key,
    required this.viewModel,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        isfavorite.value = viewModel.isFavorite;
        return Padding(
          padding: const EdgeInsets.only(top: 32.0, left: 16.0, right: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GcText(
                text: viewModel.name ?? '',
                textStyleEnum: GcTextStyleEnum.bold,
                textSize: GcTextSizeEnum.h28,
                color: AppColors.black,
                gcStyles: GcStyles.poppins,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (viewModel.headerTitle.isNotEmpty == true &&
                              viewModel.showTime == true)
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'lib/ui/assets/images/icon/clock-light.svg',
                                  height: 16,
                                  width: 16,
                                  fit: BoxFit.fill,
                                  color: AppColors.neutralLowDark,
                                ),
                                const SizedBox(width: 8.0),
                                GcText(
                                  text: viewModel.headerTitle.toLowerCase(),
                                  textStyleEnum: GcTextStyleEnum.regular,
                                  textSize: GcTextSizeEnum.callout,
                                  color: AppColors.neutralLowDark,
                                  gcStyles: GcStyles.poppins,
                                ),
                              ],
                            ),
                          const SizedBox(height: 4.0),
                          if (viewModel.location != null &&
                              viewModel.location != '')
                            GestureDetector(
                              onTap: () {
                                final presenter =
                                    Modular.get<NavigationBarPresenter>();
                                Navigator.pop(context);
                                final paramController =
                                    Modular.get<ParamController>();

                                paramController
                                    .setParam('booth-${viewModel.location}');
                                presenter.setCurrentTab(tab: TabBarItens.map);
                              },
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'lib/ui/assets/images/icon/location-dot-light.svg',
                                    height: 16,
                                    width: 16,
                                    fit: BoxFit.fill,
                                    color: AppColors.neutralLowDark,
                                  ),
                                  const SizedBox(width: 8.0),
                                  GcText(
                                    text: viewModel.location ?? '',
                                    textStyleEnum: GcTextStyleEnum.regular,
                                    textSize: GcTextSizeEnum.callout,
                                    color: AppColors.neutralLowDark,
                                    gcStyles: GcStyles.poppins,
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(height: 4.0),
                          Row(
                            children: [
                              SvgPicture.asset(
                                'lib/ui/assets/images/icon/tent-double-peak.svg',
                                height: 16,
                                width: 16,
                                fit: BoxFit.fill,
                                color: AppColors.neutralLowDark,
                              ),
                              const SizedBox(width: 8.0),
                              GcText(
                                text: viewModel.type ?? '',
                                textStyleEnum: GcTextStyleEnum.regular,
                                textSize: GcTextSizeEnum.callout,
                                color: AppColors.neutralLowDark,
                                gcStyles: GcStyles.poppins,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
