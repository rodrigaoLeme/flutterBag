import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share_plus/share_plus.dart';

import '../../../presentation/presenters/navigation_bar/tab_bar_itens.dart';
import '../../../share/utils/app_color.dart';
import '../../components/enum/design_system_enums.dart';
import '../../components/gc_text.dart';
import '../../components/themes/gc_styles.dart';
import '../../helpers/i18n/resources.dart';
import '../../mixins/mixins.dart';
import '../agenda/agenda_view_model.dart';
import '../dashboard/dashboard.dart';
import '../navigation/navigation_bar_presenter.dart';
import 'components/components.dart';
import 'components/resources_modal.dart';
import 'event_details_presenter.dart';

class EventDetailsPage extends StatefulWidget {
  final EventDetailsPresenter presenter;

  const EventDetailsPage({
    super.key,
    required this.presenter,
  });

  @override
  State<EventDetailsPage> createState() => EventDetailsPageState();
}

class EventDetailsPageState extends State<EventDetailsPage>
    with NavigationManager, LoadingManager {
  bool shouldReload = false;
  @override
  void initState() {
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
    return Builder(
      builder: (context) {
        widget.presenter.convinienceInit();

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop) Modular.to.pop(shouldReload);
          },
          child: Scaffold(
            backgroundColor: AppColors.white,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: AppColors.primaryLight,
              leading: GestureDetector(
                onTap: () {
                  Modular.to.pop(shouldReload);
                },
                behavior: HitTestBehavior.translucent,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: const Icon(
                    Icons.arrow_back,
                    color: AppColors.white,
                  ),
                ),
              ),
              title: Align(
                alignment: Alignment.topLeft,
                child: GcText(
                  text: R.string.detailsLabel,
                  gcStyles: GcStyles.poppins,
                  textSize: GcTextSizeEnum.h3w5,
                  textStyleEnum: GcTextStyleEnum.semibold,
                  color: AppColors.white,
                ),
              ),
            ),
            body: StreamBuilder<ScheduleViewModel?>(
              stream: widget.presenter.scheduleViewModel,
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return const SizedBox.shrink();
                }
                final viewModel = snapshot.data;
                String nomesPalestrantes = viewModel?.speakers
                        ?.map((speaker) => speaker.fullName)
                        .where((name) => name != null && name.isNotEmpty)
                        .join(', ') ??
                    '';
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 16.0,
                          top: 24.0,
                          right: 16.0,
                        ),
                        child: GcText(
                          text: viewModel?.name ?? '',
                          gcStyles: GcStyles.poppins,
                          textSize: GcTextSizeEnum.h2,
                          textStyleEnum: GcTextStyleEnum.bold,
                          color: AppColors.neutralLowDark,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 16.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'lib/ui/assets/images/icon/calendar-regular.svg',
                                  height: 13,
                                  width: 13,
                                  fit: BoxFit.fill,
                                  color: AppColors.neutralLowMedium,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: GcText(
                                    text: viewModel?.headerTitleDetails ?? '',
                                    gcStyles: GcStyles.poppins,
                                    textSize: GcTextSizeEnum.callout,
                                    textStyleEnum: GcTextStyleEnum.regular,
                                    color: AppColors.neutralLowMedium,
                                  ),
                                ),
                              ],
                            ),
                            if (viewModel?.location?.isNotEmpty == true)
                              GestureDetector(
                                onTap: () {
                                  openMap(viewModel);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 12.0, right: 16.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        'lib/ui/assets/images/icon/location-dot-light.svg',
                                        height: 13,
                                        width: 13,
                                        fit: BoxFit.fill,
                                        color: AppColors.neutralLowMedium,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: GcText(
                                          text: viewModel?.location ?? '',
                                          textSize: GcTextSizeEnum.callout,
                                          textStyleEnum:
                                              GcTextStyleEnum.regular,
                                          color: AppColors.neutralLowMedium,
                                          gcStyles: GcStyles.poppins,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 16.0, left: 16.0, right: 16.0),
                        child: Row(
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
                                  viewModel?.isFavorite == true
                                      ? 'lib/ui/assets/images/icon/heart-solid.svg'
                                      : 'lib/ui/assets/images/icon/heart-light.svg',
                                  color: AppColors.primaryLight,
                                  width: 18,
                                  height: 18,
                                ),
                                onPressed: () {
                                  if (viewModel != null) {
                                    shouldReload = true;
                                    widget.presenter
                                        .saveFavorites(event: viewModel);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Container(
                              width: 48,
                              height: 48,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.neutralLight,
                              ),
                              child: IconButton(
                                icon: SvgPicture.asset(
                                  'lib/ui/assets/images/icon/share-nodes-light.svg',
                                  color: AppColors.primaryLight,
                                  width: 18,
                                  height: 18,
                                ),
                                onPressed: () async {
                                  final texto = StringBuffer();
                                  final name = viewModel?.name;
                                  final timezone = viewModel?.timezone;
                                  final description = viewModel?.description;
                                  final location = viewModel?.location;

                                  if (name?.isNotEmpty == true) {
                                    texto.writeln(name);
                                  }
                                  if (timezone?.isNotEmpty == true) {
                                    texto.writeln('🕒 $timezone');
                                  }
                                  if (description?.isNotEmpty == true) {
                                    texto.writeln('📄 $description');
                                  }
                                  if (nomesPalestrantes.isNotEmpty) {
                                    texto.writeln('👤 $nomesPalestrantes');
                                  }
                                  if (location?.isNotEmpty == true) {
                                    texto.writeln('📍 $location');
                                  }
                                  await Share.share(texto.toString().trim(),
                                      subject: name);
                                },
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Container(
                              width: 48,
                              height: 48,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.neutralLight,
                              ),
                              child: IconButton(
                                icon: SvgPicture.asset(
                                  'lib/ui/assets/images/icon/diamond-turn-right-light.svg',
                                  color: AppColors.primaryLight,
                                  width: 18,
                                  height: 18,
                                ),
                                onPressed: () {
                                  openMap(viewModel);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (viewModel?.description?.isNotEmpty == true)
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 24.0, bottom: 8.0, left: 16.0),
                          child: GcText(
                            text: R.string.descriptionLabel,
                            textSize: GcTextSizeEnum.h2,
                            textStyleEnum: GcTextStyleEnum.bold,
                            color: AppColors.black,
                            gcStyles: GcStyles.poppins,
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16.0, bottom: 24.0),
                        child: GcText(
                          text: viewModel?.description ?? '',
                          textSize: GcTextSizeEnum.subheadline,
                          textStyleEnum: GcTextStyleEnum.regular,
                          color: AppColors.black,
                          gcStyles: GcStyles.poppins,
                        ),
                      ),
                      if ((snapshot.data?.speakers?.length ?? 0) > 0)
                        TodaysSpeakersSection(
                            viewModel: snapshot.data?.speakers),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 32.0, horizontal: 16.0),
                        child: SizedBox(
                          height: 104,
                          child: Row(
                            children: [
                              if (viewModel?.files?.isEmpty == false)
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (context) => ResourcesModal(
                                          viewModel: viewModel,
                                        ),
                                      );
                                    },
                                    child: MenuCell(
                                      title: R.string.resourcesLabel,
                                      iconPath:
                                          'lib/ui/assets/images/icon/folder-light.svg',
                                      iconColor: AppColors.primaryLight,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16.0,
                                        color: AppColors.primaryLight,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void openMap(ScheduleViewModel? viewModel) {
    final paramController = Modular.get<ParamController>();

    final presenter = Modular.get<NavigationBarPresenter>();

    final mapViewModel = paramController.getViewModel();

    final path = mapViewModel?.rooms
        ?.firstWhereOrNull((element) => element.value == viewModel?.location);

    paramController.setParam(path?.key ?? '');

    presenter.setCurrentTab(tab: TabBarItens.map);
    Modular.to.pop(shouldReload);
  }
}
