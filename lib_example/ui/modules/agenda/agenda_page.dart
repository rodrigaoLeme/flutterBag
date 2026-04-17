import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../main/routes/routes.dart';
import '../../../presentation/mixins/push_fullscreen_manager.dart';
import '../../../share/utils/app_color.dart';
import '../../components/empty_state.dart';
import '../../components/enum/design_system_enums.dart';
import '../../components/gc_text.dart';
import '../../components/themes/gc_styles.dart';
import '../../helpers/i18n/resources.dart';
import '../../mixins/mixins.dart';
import '../../mixins/push_fullscreen_manager.dart';
import '../food/components/filter_costum.dart';
import '../modules.dart';
import 'components/event_section.dart';

// ignore: must_be_immutable
class AgendaPage extends StatefulWidget {
  final AgendaPresenter presenter;
  bool? firstFilterScroll = true;
  bool? firstCustomScroll = true;

  AgendaPage({
    super.key,
    required this.presenter,
  });
  @override
  AgendaPageState createState() => AgendaPageState();
}

class AgendaPageState extends State<AgendaPage>
    with NavigationManager, LoadingManager, TickerProviderStateMixin {
  final ScrollController _eventScrollController = ScrollController();
  Map<String, GlobalKey> itemKeys = {};
  ValueNotifier<String?> customScroll = ValueNotifier(null);
  ValueNotifier<String?> customFilterScroll = ValueNotifier(null);
  final ValueNotifier<int?> _currentTab = ValueNotifier(null);
  late TabController _tabController;

  bool tabBarIsInitialized = false;
  Future<void> _goToDetails(detailsViewModel) async {
    final result = await Modular.to.pushNamed(
      Routes.eventDetails,
      arguments: detailsViewModel,
    );
    if (result == true) {
      widget.presenter.loadData();
    }
  }

  @override
  void initState() {
    PushFullscreenManagerListener.handleFullScreen(
        context, PushFullscreenManager().isShowingStream);
    handleNavigation(widget.presenter.navigateToStream);
    handleLoading(context, widget.presenter.isLoadingStream);
    _tabController = TabController(length: 2, vsync: this);
    customScroll.addListener(() async {
      if (widget.firstCustomScroll == true) {
        await Future.delayed(const Duration(microseconds: 500));

        String key = customScroll.value ?? '';
        scrollToIndex(key);
        widget.firstCustomScroll = false;
      }
    });

    customFilterScroll.addListener(() async {
      if (widget.firstFilterScroll == true) {
        await Future.delayed(const Duration(microseconds: 500));

        String key = customFilterScroll.value ?? '';
        scrollToIndex(key);
        widget.firstFilterScroll = false;
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    widget.presenter.dispose();
    _eventScrollController.dispose();
    super.dispose();
  }

  void scrollToIndex(String key) {
    final context = itemKeys[key]?.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        widget.presenter.loadData();
        final navigationArgs = Modular.args.data;

        SchedulePageNavigationData? navigationData;
        if (navigationArgs is SchedulePageNavigationData) {
          navigationData = navigationArgs;
        } else {
          navigationData = SchedulePageNavigationData(
            currentIndex: 0,
            shouldPresentArrowBack: false,
          );
        }
        if (!tabBarIsInitialized) {
          _tabController.index = navigationData.currentIndex;
          tabBarIsInitialized = true;
        }

        return DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: AppColors.white,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: AppColors.primaryLight,
              title: Align(
                alignment: Alignment.topLeft,
                child: GcText(
                  text: R.string.scheduleLabel,
                  textSize: GcTextSizeEnum.h3w5,
                  textStyleEnum: GcTextStyleEnum.regular,
                  color: AppColors.white,
                  gcStyles: GcStyles.poppins,
                ),
              ),
              leading: navigationData.shouldPresentArrowBack == true
                  ? GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      behavior: HitTestBehavior.translucent,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: const Icon(
                          Icons.arrow_back,
                          color: AppColors.white,
                        ),
                      ),
                    )
                  : null,
            ),
            body: StreamBuilder<AgendaViewModel?>(
              stream: widget.presenter.viewModel,
              builder: (context, snapshotAgendaViewModel) {
                AgendaViewModel? agendaViewModel = snapshotAgendaViewModel.data;
                if (agendaViewModel == null) {
                  return const SizedBox.shrink();
                }
                customScroll.value = agendaViewModel.currentFilter?.filter;
                _tabController.index = _tabController.index;
                return Column(
                  children: [
                    TabBar(
                      controller: _tabController,
                      indicatorColor: AppColors.primaryLight,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelColor: AppColors.primaryLight,
                      labelStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      tabs: [
                        for (ScheduleTabs tab in agendaViewModel.tabs)
                          Tab(
                            text: tab.filterTitle.toUpperCase(),
                          ),
                      ],
                      onTap: (index) {
                        _currentTab.value = index;
                        setState(() {});
                      },
                    ),
                    ValueListenableBuilder(
                        valueListenable: _currentTab,
                        builder: (context, snapshot, _) {
                          final filters = (_tabController.index == 0
                              ? agendaViewModel.filters
                              : agendaViewModel.favoriteFilter);
                          final hasFilter = filters.firstWhereOrNull(
                              (element) =>
                                  element.date ==
                                  agendaViewModel.currentFilter?.date);
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.07,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: filters.map((filter) {
                                bool isSelectedFilter = filter.date ==
                                    agendaViewModel.currentFilter?.date;
                                if (hasFilter == null &&
                                    filter.isShowAllItems) {
                                  isSelectedFilter = true;
                                  widget.presenter.selectCurrentFilter(
                                    filter: filter,
                                    viewModel: agendaViewModel,
                                  );
                                }
                                final globalKey = GlobalKey();
                                itemKeys[filter.filter] = globalKey;
                                if (isSelectedFilter) {
                                  customFilterScroll.value = filter.filter;
                                }
                                return Padding(
                                  key: globalKey,
                                  padding: const EdgeInsets.only(
                                      left: 6.0, top: 12.0, right: 6.0),
                                  child: FilterCostum(
                                    text: filter.filter.toUpperCase(),
                                    backgroundColor: isSelectedFilter
                                        ? AppColors.primaryLight
                                        : AppColors.neutralLight,
                                    textColor: isSelectedFilter
                                        ? AppColors.white
                                        : AppColors.primaryLight,
                                    onTap: () {
                                      widget.presenter.selectCurrentFilter(
                                        filter: filter,
                                        viewModel: agendaViewModel,
                                      );
                                      _eventScrollController.jumpTo(0);
                                      scrollToIndex(
                                        filter.filter,
                                      );
                                    },
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                        }),
                    Expanded(
                      child: TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: _tabController,
                        children: [
                          for (int i = 0;
                              i < (agendaViewModel.tabs.length);
                              i++)
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Builder(
                                builder: (context) {
                                  final tab = agendaViewModel.tabs[i];
                                  if (tab.currentSection == null ||
                                      tab.originalItens.isEmpty) {
                                    return i == 0
                                        ? EmptyState(
                                            icon:
                                                'lib/ui/assets/images/icon/calendar.svg',
                                            title: R.string.messageEmpty,
                                          )
                                        : EmptyState(
                                            icon:
                                                'lib/ui/assets/images/icon/calendar-star.svg',
                                            title:
                                                R.string.messageEmptyMySchedule,
                                          );
                                  } else {
                                    return EventSection(
                                      viewModel: tab,
                                      onPressed: (selectedSchedule) {
                                        if (selectedSchedule != null) {
                                          widget.presenter.saveFavorites(
                                            event: selectedSchedule,
                                            viewModel: agendaViewModel,
                                          );
                                        }
                                      },
                                      goToDetails: (item) async {
                                        await _goToDetails(item);
                                      },
                                      scrollController: _eventScrollController,
                                    );
                                  }
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
