import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../presentation/presenters/navigation_bar/tab_bar_itens.dart';
import '../../../../share/utils/app_color.dart';
import '../../../components/empty_state.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/html_view_page.dart';
import '../../../components/themes/gc_styles.dart';
import '../../../helpers/i18n/resources.dart';
import '../../../mixins/loading_manager.dart';
import '../../../mixins/navigation_manager.dart';
import '../../navigation/navigation_bar_presenter.dart';
import '../spiritual_view_model.dart';
import 'prayer_room_presenter.dart';

class PrayerRoomPage extends StatefulWidget {
  final PrayerRoomPresenter presenter;
  const PrayerRoomPage({
    super.key,
    required this.presenter,
  });

  @override
  PrayerRoomState createState() => PrayerRoomState();
}

class PrayerRoomState extends State<PrayerRoomPage>
    with NavigationManager, LoadingManager {
  bool shouldReload = true;
  @override
  void initState() {
    widget.presenter.convinienceInit();
    handleNavigation(widget.presenter.navigateToStream);
    handleLoading(context, widget.presenter.isLoadingStream);
    super.initState();
  }

  @override
  void dispose() {
    widget.presenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primaryLight,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          behavior: HitTestBehavior.translucent,
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Icon(
              Icons.arrow_back,
              color: AppColors.white,
            ),
          ),
        ),
        title: Align(
          alignment: Alignment.topLeft,
          child: GcText(
            text: R.string.prayerRoomLabel,
            gcStyles: GcStyles.poppins,
            textSize: GcTextSizeEnum.h3w5,
            textStyleEnum: GcTextStyleEnum.regular,
            color: AppColors.white,
          ),
        ),
      ),
      body: StreamBuilder<PrayerRoomViewModel?>(
        stream: widget.presenter.viewModel,
        builder: (context, snapshot) {
          final viewModel = snapshot.data;
          if (viewModel == null) {
            return EmptyState(
              icon: 'lib/ui/assets/images/icon/hands-praying.svg',
              title: R.string.messageEmpty,
            );
          }
          final hasText = (viewModel.text ?? '').trim().isNotEmpty;
          final hasHeader = viewModel.headerTitleDetails.isNotEmpty ||
              (viewModel.location ?? '').isNotEmpty;
          final hasAnyContent = hasText || hasHeader;
          if (!hasAnyContent) {
            return EmptyState(
              icon: 'lib/ui/assets/images/icon/hands-praying.svg',
              title: R.string.messageEmpty,
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasHeader) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 24),
                  child: GcText(
                    text: R.string.prayerRoomLabel,
                    gcStyles: GcStyles.poppins,
                    textSize: GcTextSizeEnum.h2,
                    textStyleEnum: GcTextStyleEnum.bold,
                    color: AppColors.neutralLowDark,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 16,
                  ),
                  child: Column(
                    children: [
                      if (viewModel.headerTitleDetails.isNotEmpty)
                        Row(
                          children: [
                            SvgPicture.asset(
                              'lib/ui/assets/images/icon/calendar-regular.svg',
                              height: 15,
                              width: 15,
                              color: AppColors.neutralLowMedium,
                            ),
                            const SizedBox(width: 8),
                            GcText(
                              text: viewModel.headerTitleDetails,
                              gcStyles: GcStyles.poppins,
                              textSize: GcTextSizeEnum.callout,
                              textStyleEnum: GcTextStyleEnum.regular,
                              color: AppColors.neutralLowMedium,
                            ),
                          ],
                        ),
                      if ((viewModel.location ?? '').isNotEmpty)
                        GestureDetector(
                          onTap: () {
                            final paramController =
                                Modular.get<ParamController>();
                            final presenter =
                                Modular.get<NavigationBarPresenter>();
                            final mapViewModel = paramController.getViewModel();
                            final path = mapViewModel?.rooms?.firstWhereOrNull(
                              (element) => element.value == viewModel.location,
                            );
                            paramController.setParam(path?.key ?? '');
                            presenter.setCurrentTab(
                              tab: TabBarItens.map,
                            );
                            Modular.to.pop(shouldReload);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'lib/ui/assets/images/icon/location-dot-light.svg',
                                  height: 15,
                                  width: 15,
                                  color: AppColors.neutralLowMedium,
                                ),
                                const SizedBox(width: 8),
                                GcText(
                                  text: viewModel.location ?? '',
                                  textSize: GcTextSizeEnum.callout,
                                  textStyleEnum: GcTextStyleEnum.regular,
                                  color: AppColors.neutralLowMedium,
                                  gcStyles: GcStyles.poppins,
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
              if (hasText)
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: CustomHtml(
                        htmlData: viewModel.text ?? '',
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }
}
