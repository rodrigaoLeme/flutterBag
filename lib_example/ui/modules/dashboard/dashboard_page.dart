import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';
import 'package:open_filex/open_filex.dart';

import '../../../infra/download/file_download.dart';
import '../../../infra/firebase/feature_flag.dart';
import '../../../main/routes/routes_app.dart';
import '../../../presentation/mixins/push_fullscreen_manager.dart';
import '../../../presentation/presenters/navigation_bar/tab_bar_itens.dart';
import '../../../share/utils/app_color.dart';
import '../../components/empty_state_view.dart';
import '../../components/enum/design_system_enums.dart';
import '../../components/gc_text.dart';
import '../../components/themes/gc_styles.dart';
import '../../helpers/extensions/string_extension.dart';
import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import '../../mixins/push_fullscreen_manager.dart';
import '../accessibility/accessibility_page.dart';
import '../exhibition/components/favorites_exhibitions_bottom_sheet.dart';
import '../food/food_view_model.dart';
import '../modules.dart';
import '../navigation/navigation_bar_presenter.dart';
import '../voting/component/user_voting_section.dart';
import '../voting/component/votings_stories_page.dart';
import '../web_view/web_view_page.dart';
import 'components/actions_section.dart';
import 'components/banner_carousel_section.dart';
import 'components/exhibitions_section.dart';
import 'components/home_card_view.dart';
import 'components/restaurant_card_section.dart';
import 'section_view_model.dart';
import 'sponsor_view_model.dart';

class DashboardPage extends StatefulWidget {
  final DashboardPresenter presenter;
  final NavigationBarPresenter tabBarPresenter;

  const DashboardPage({
    super.key,
    required this.presenter,
    required this.tabBarPresenter,
  });

  @override
  State<DashboardPage> createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage>
    with NavigationManager, LoadingManager {
  bool isDownloading = false;

  @override
  void initState() {
    widget.presenter.loadSections();
    widget.presenter.loadNotificationReadCount();
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
        handleNavigation(widget.presenter.navigateToStream);
        PushFullscreenManagerListener.handleFullScreen(
            context, PushFullscreenManager().isShowingStream);
        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: AppColors.primaryLight,
            automaticallyImplyLeading: false,
            title: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: SizedBox(
                      height: 38.0,
                      width: 38.0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.zero,
                        child: Image.asset(
                          'lib/ui/assets/images/logo/logos.png',
                          fit: BoxFit.contain,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await Modular.to.pushNamed(
                            Routes.notification,
                          );
                          widget.presenter.loadNotificationReadCount();
                        },
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            SvgPicture.asset(
                              'lib/ui/assets/images/icon/bell-solid.svg',
                              height: 26,
                              width: 26,
                              color: AppColors.white,
                            ),
                            ValueListenableBuilder(
                              valueListenable:
                                  widget.presenter.notificationReadCount,
                              builder: (context, snapshot, _) {
                                final count = snapshot;
                                return Positioned(
                                  top: -4,
                                  right: -4,
                                  child: count == null
                                      ? const SizedBox.shrink()
                                      : Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 2),
                                          alignment: Alignment.center,
                                          decoration: const BoxDecoration(
                                            color: AppColors.error,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: GcText(
                                              textAlign: TextAlign.center,
                                              text: '$count',
                                              gcStyles: GcStyles.poppins,
                                              textSize: GcTextSizeEnum.caption1,
                                              color: AppColors.white,
                                              overflow: TextOverflow.visible,
                                            ),
                                          ),
                                        ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          body: StreamBuilder<SectionsViewModel?>(
            stream: widget.presenter.viewModel,
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return const SizedBox.shrink();
              }
              if (snapshot.data?.sections?.isEmpty == true) {
                return EmptyStateView(
                  icon: 'lib/ui/assets/images/icon/error_icon.png',
                  title: R.string.noEventFound,
                  subtitle: R.string.eventsAvailableSoon,
                );
              }
              widget.presenter.convinienceInit();
              final sections = snapshot.data?.sectionTypeList;
              return SingleChildScrollView(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: sections?.length,
                  itemBuilder: (context, index) {
                    final section = sections?[index];

                    switch (section) {
                      case SectionType.schedule:
                        return Container(
                          color: AppColors.cardLigth,
                          child: Builder(builder: (context) {
                            widget.presenter.fetchAgenda();

                            return StreamBuilder<AgendaViewModel?>(
                              stream: widget.presenter.agendaViewModel,
                              builder: (context, snapshot) {
                                final agendaViewModel = snapshot.data;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0),
                                  child: SizedBox(
                                    height:
                                        agendaViewModel?.homeCardsHeight ?? 400,
                                    child: HomeCardView(
                                      presenter: widget.presenter,
                                      viewModel: agendaViewModel,
                                      onPressed: (index) {
                                        Future.microtask(
                                          () {
                                            Modular.to.pushReplacementNamed(
                                              Modular.to.path,
                                              arguments:
                                                  SchedulePageNavigationData(
                                                currentIndex: index,
                                                shouldPresentArrowBack: false,
                                              ),
                                            );
                                          },
                                        );
                                        widget.tabBarPresenter.setCurrentTab(
                                          tab: TabBarItens.schedule,
                                        );
                                      },
                                      connectionState: snapshot.connectionState,
                                      goToDetails:
                                          (agendaDetailsViewModel) async {
                                        final bool reload = await Modular.to
                                                .pushNamed(Routes.eventDetails,
                                                    arguments:
                                                        agendaDetailsViewModel)
                                            as bool;
                                        if (reload == true) {
                                          widget.presenter.fetchAgenda();
                                        }
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          }),
                        );
                      case SectionType.news:
                        return Builder(
                          builder: (context) {
                            widget.presenter.fetchNews();

                            return StreamBuilder<NewsListViewModel?>(
                              stream: widget.presenter.newsViewModel,
                              builder: (context, snapshot) {
                                final newsViewModel = snapshot.data;
                                if (newsViewModel == null ||
                                    newsViewModel.newsList.isEmpty == true) {
                                  return const SizedBox.shrink();
                                }
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 6, right: 16.0, top: 28.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextButton(
                                            onPressed:
                                                widget.presenter.goToNews,
                                            child: GcText(
                                              text: R.string.newsLabel,
                                              textSize: GcTextSizeEnum.h3,
                                              textStyleEnum:
                                                  GcTextStyleEnum.bold,
                                              color: AppColors.black,
                                              gcStyles: GcStyles.poppins,
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed:
                                                widget.presenter.goToNews,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.neutralLight,
                                              elevation: 0,
                                            ),
                                            child: GcText(
                                              text: R.string.seeAllButon,
                                              textSize: GcTextSizeEnum.subhead,
                                              textStyleEnum:
                                                  GcTextStyleEnum.regular,
                                              color: AppColors.primaryLight,
                                              gcStyles: GcStyles.poppins,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (FeatureFlags()
                                            .getDailyBulletinBannerUrl() !=
                                        '')
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0,
                                            bottom: 16.0,
                                            left: 16.0,
                                            right: 16.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            openUrl(
                                              Uri.parse(
                                                FeatureFlags()
                                                    .getDailyBulletinBannerUrl()
                                                    .normalizarUrl,
                                              ),
                                            );
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 32, vertical: 20),
                                            decoration: BoxDecoration(
                                              color: AppColors.primaryLight,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SvgPicture.asset(
                                                  'lib/ui/assets/images/icon/news_icon.svg',
                                                  color: AppColors.white,
                                                ),
                                                const SizedBox(width: 16),
                                                Expanded(
                                                  child: GcText(
                                                    text:
                                                        R.string.bulletinLabel,
                                                    gcStyles: GcStyles.poppins,
                                                    textSize:
                                                        GcTextSizeEnum.h4w500,
                                                    textStyleEnum:
                                                        GcTextStyleEnum.regular,
                                                    color: AppColors.white,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    SizedBox(
                                      height: 260,
                                      child: InformationSection(
                                        onTap: (newsItem) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => WebViewPage(
                                                url: newsItem.details?.link ??
                                                    '',
                                                title: R.string.newsLabel,
                                              ),
                                            ),
                                          );
                                        },
                                        newsViewModel: newsViewModel,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      case SectionType.sponsor:
                        return Builder(
                          builder: (context) {
                            widget.presenter.loadSponsors();
                            return StreamBuilder<SponsorsViewModel?>(
                              stream: widget.presenter.sponsorsViewModel,
                              builder: (context, snapshot) {
                                final viewModel = snapshot.data;
                                if (viewModel == null ||
                                    viewModel.sponsors?.isEmpty == true) {
                                  return const SizedBox.shrink();
                                }
                                return SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.21,
                                  child: BannerCarouselSection(
                                    viewModel: viewModel,
                                  ),
                                );
                              },
                            );
                          },
                        );
                      case SectionType.exhibitions:
                        return Builder(
                          builder: (context) {
                            widget.presenter.loadExhibitions();

                            return StreamBuilder<ExhibitionsViewModel?>(
                              stream: widget.presenter.exhibitionViewModel,
                              builder: (context, snapshot) {
                                final exhibitionViewModel = snapshot.data;
                                if (exhibitionViewModel == null ||
                                    exhibitionViewModel.exhibitions.isEmpty) {
                                  return const SizedBox.shrink();
                                }
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, top: 24.0, right: 16.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              widget.tabBarPresenter
                                                  .setCurrentTab(
                                                      tab: TabBarItens
                                                          .exhibitions);
                                            },
                                            child: GcText(
                                              text: R.string.exhibitionsLabel,
                                              textSize: GcTextSizeEnum.h3,
                                              textStyleEnum:
                                                  GcTextStyleEnum.bold,
                                              color: AppColors.black,
                                              gcStyles: GcStyles.poppins,
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              widget.tabBarPresenter
                                                  .setCurrentTab(
                                                      tab: TabBarItens
                                                          .exhibitions);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.neutralLight,
                                              elevation: 0,
                                            ),
                                            child: GcText(
                                              text: R.string.seeAllButon,
                                              textSize: GcTextSizeEnum.subhead,
                                              textStyleEnum:
                                                  GcTextStyleEnum.regular,
                                              color: AppColors.primaryLight,
                                              gcStyles: GcStyles.poppins,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      color: AppColors.white,
                                      child: ExhibitionsSection(
                                        exhibitionViewModel:
                                            exhibitionViewModel,
                                        onTap: (exhibitionViewModel) {
                                          if (exhibitionViewModel != null) {
                                            showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              builder: (context) =>
                                                  FavoritesExhibitionsBottomSheet(
                                                viewModel: exhibitionViewModel,
                                                onFavoriteToggle:
                                                    (exhibitionViewModel) async {
                                                  return await widget.presenter
                                                      .savedFavorites(
                                                          exhibitor:
                                                              exhibitionViewModel);
                                                },
                                                onTapDownload: (file) async {
                                                  await onTapDownload(file);
                                                },
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      case SectionType.spiritual:
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.16,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 24.0),
                            child: GestureDetector(
                              onTap: () {
                                widget.presenter.goToSpiritual();
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: BorderRadius.circular(8.0),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: AppColors.neutralHigh,
                                      spreadRadius: 3,
                                      blurRadius: 14,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Stack(
                                      clipBehavior: Clip.none,
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          height: 38,
                                          width: 38,
                                          decoration: BoxDecoration(
                                            color: AppColors.wine,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: AppColors.wine,
                                              width: 2.0,
                                            ),
                                          ),
                                          child: Center(
                                            child: SvgPicture.asset(
                                              'lib/ui/assets/images/icon/book-bible-regular.svg',
                                              height: 16,
                                              width: 16,
                                              color: AppColors.white,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          left: 24,
                                          child: Container(
                                            height: 42,
                                            width: 42,
                                            decoration: BoxDecoration(
                                              color: AppColors.orange,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: AppColors.white,
                                                width: 2.0,
                                              ),
                                            ),
                                            child: Center(
                                              child: SvgPicture.asset(
                                                'lib/ui/assets/images/icon/person-praying-regular.svg',
                                                height: 16,
                                                width: 16,
                                                color: AppColors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          left: 48,
                                          child: Container(
                                            height: 42,
                                            width: 42,
                                            decoration: BoxDecoration(
                                              color: AppColors.greemWater,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: AppColors.white,
                                                width: 2.0,
                                              ),
                                            ),
                                            child: Center(
                                              child: SvgPicture.asset(
                                                'lib/ui/assets/images/icon/music-regular.svg',
                                                height: 16,
                                                width: 16,
                                                color: AppColors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 16.0),
                                      child: GcText(
                                        text: R.string.spiritualLabel,
                                        textSize: GcTextSizeEnum.h3w5,
                                        textStyleEnum: GcTextStyleEnum.regular,
                                        color: AppColors.neutralLowDark,
                                        gcStyles: GcStyles.notoSerif,
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 16,
                                      color: AppColors.neutralLowDark,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );

                      case SectionType.restaurants:
                        return Builder(
                          builder: (context) {
                            widget.presenter.fetchFood();

                            return StreamBuilder<FoodViewModel?>(
                              stream: widget.presenter.foodViewModel,
                              builder: (context, snapshot) {
                                final foodViewModel = snapshot.data;
                                if (foodViewModel == null) {
                                  return const SizedBox.shrink();
                                }
                                return Column(
                                  children: [
                                    SizedBox(
                                      height: 72,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 8,
                                          right: 16,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                widget.presenter.goToFood(
                                                    SectionType
                                                        .restaurantsInternal);
                                              },
                                              child: GcText(
                                                text: R.string.foodLabel,
                                                textSize: GcTextSizeEnum.h3,
                                                textStyleEnum:
                                                    GcTextStyleEnum.bold,
                                                color: AppColors.black,
                                                gcStyles: GcStyles.poppins,
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                widget.presenter.goToFood(
                                                    SectionType
                                                        .restaurantsInternal);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    AppColors.neutralLight,
                                                elevation: 0,
                                              ),
                                              child: GcText(
                                                text: R.string.seeAllButon,
                                                textSize:
                                                    GcTextSizeEnum.subhead,
                                                textStyleEnum:
                                                    GcTextStyleEnum.regular,
                                                color: AppColors.primaryLight,
                                                gcStyles: GcStyles.poppins,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: ResponsiveLayout.of(context).width,
                                      height: 178,
                                      child: Center(
                                        child: RestaurantCardSection(
                                          sections: const [
                                            SectionType.restaurantsInternal,
                                            SectionType.restaurantsExternal,
                                          ],
                                          onTap: (sectionType) {
                                            switch (sectionType) {
                                              case SectionType
                                                    .restaurantsInternal:
                                                widget.presenter.goToFood(
                                                    SectionType
                                                        .restaurantsInternal);
                                              case SectionType
                                                    .restaurantsExternal:
                                                widget.presenter.goToFood(
                                                    SectionType
                                                        .restaurantsExternal);
                                              default:
                                                break;
                                            }
                                          },
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              },
                            );
                          },
                        );

                      case SectionType.newlyElected:
                        return Builder(
                          builder: (context) {
                            widget.presenter.fetchVotings();

                            return ValueListenableBuilder(
                              valueListenable: widget.presenter.votingViewModel,
                              builder: (context, snapshotVoting, _) {
                                final votingViewModel = snapshotVoting;
                                if (votingViewModel == null ||
                                    votingViewModel.votings.isEmpty) {
                                  return const SizedBox.shrink();
                                }

                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 8.0,
                                        left: 4,
                                        right: 16,
                                        bottom: 12,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: TextButton(
                                              onPressed: () {
                                                widget.presenter.goToVoting();
                                              },
                                              child: GcText(
                                                text:
                                                    R.string.votingResultsLabel,
                                                textSize: GcTextSizeEnum.h3,
                                                textStyleEnum:
                                                    GcTextStyleEnum.bold,
                                                color: AppColors.black,
                                                gcStyles: GcStyles.poppins,
                                                maxLines: 2,
                                              ),
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              widget.presenter.goToVoting();
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.neutralLight,
                                              elevation: 0,
                                            ),
                                            child: GcText(
                                              text: R.string.seeAllButon,
                                              textSize: GcTextSizeEnum.subhead,
                                              textStyleEnum:
                                                  GcTextStyleEnum.regular,
                                              color: AppColors.primaryLight,
                                              gcStyles: GcStyles.poppins,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 174,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: UserVotingSection(
                                          viewModel: votingViewModel,
                                          onTap: (votingItem) {
                                            final allViewModels =
                                                votingViewModel.votings;
                                            final index = allViewModels
                                                .indexOf(votingItem);

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    VotingStoriesPage(
                                                  viewModels: allViewModels,
                                                  initialIndex: index,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );

                      case SectionType.actions:
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: SizedBox(
                            height: 128,
                            child: ActionSection(
                              sections: const [
                                SectionType.business,
                                SectionType.liveStream,
                                SectionType.documents,
                              ],
                              onTap: (sectionType) {
                                switch (sectionType) {
                                  case SectionType.business:
                                    widget.presenter.goToBusiness();
                                  case SectionType.liveStream:
                                    widget.presenter.goToBroadcast();
                                  case SectionType.documents:
                                    widget.presenter.goToDocuments();

                                  default:
                                    break;
                                }
                              },
                            ),
                          ),
                        );
                      case SectionType.bottomMenu:
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SizedBox(
                            height: 228,
                            child: Column(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            widget.presenter.goToEmergency();
                                          },
                                          child: MenuCell(
                                            title: R.string.emergencyLabel,
                                            iconPath:
                                                'lib/ui/assets/images/icon/truck-medical-regular.svg',
                                            iconColor: AppColors.primaryLight,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16.0,
                                              color: AppColors.primaryLight,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            widget.presenter.goToSupport();
                                          },
                                          child: MenuCell(
                                            title: R.string.faqLabel,
                                            iconPath:
                                                'lib/ui/assets/images/icon/comments-question-check-regular.svg',
                                            iconColor: AppColors.primaryLight,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16.0,
                                              color: AppColors.primaryLight,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  height: 108,
                                  width: double.infinity,
                                  child: GestureDetector(
                                    onTap: () {
                                      widget.presenter.goToTranslationChannel();
                                    },
                                    child: MenuCell(
                                      title: R.string.translationChanelLabel,
                                      iconPath:
                                          'lib/ui/assets/images/icon/TRANSLATION_CHANNEL.svg',
                                      iconColor: AppColors.primaryLight,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16.0,
                                        color: AppColors.primaryLight,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );

                      default:
                        return const SizedBox.shrink();
                    }
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> onTapDownload(FilesViewModel? file) async {
    if (isDownloading) return;
    widget.presenter.showLoadingFlow(loading: true);
    isDownloading = true;
    try {
      final filePath = await PDFDownloader.downloadAndOpenPDF(
        file?.storagePath ?? '',
        file?.name ?? '',
      );
      OpenFilex.open(filePath);
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(R.string.anErrorHasOccurred),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      isDownloading = false;
      widget.presenter.showLoadingFlow(loading: false);
    }
  }
}
