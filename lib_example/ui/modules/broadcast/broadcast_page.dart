import 'package:flutter/material.dart';

import '../../../share/utils/app_color.dart';
import '../../components/empty_state.dart';
import '../../components/enum/design_system_enums.dart';
import '../../components/gc_text.dart';
import '../../components/themes/gc_styles.dart';
import '../../components/youtube_player_web_view.dart';
import '../../helpers/i18n/resources.dart';
import '../../mixins/navigation_manager.dart';
import '../food/components/filter_costum.dart';
import 'broadcast_presenter.dart';
import 'broadcast_view_model.dart';
import 'components/previous_section.dart';
import 'components/video_details.dart';

class BroadcastPage extends StatefulWidget {
  final BroadcastPresenter presenter;

  const BroadcastPage({
    super.key,
    required this.presenter,
  });

  @override
  BroadcastPageState createState() => BroadcastPageState();
}

class BroadcastPageState extends State<BroadcastPage>
    with NavigationManager, TickerProviderStateMixin {
  late TabController _tabController;
  bool initializedTabBar = false;

  @override
  void initState() {
    handleNavigation(widget.presenter.navigateToStream);
    widget.presenter.loadData();
    widget.presenter.fetchAgenda();
    _tabController = TabController(length: 3, vsync: this);
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
        backgroundColor: AppColors.primaryLight,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Align(
          alignment: Alignment.centerLeft,
          child: GcText(
            text: R.string.liveBroadcastLabel,
            textStyleEnum: GcTextStyleEnum.regular,
            textSize: GcTextSizeEnum.h3w5,
            color: AppColors.white,
            gcStyles: GcStyles.poppins,
          ),
        ),
      ),
      body: StreamBuilder<BroadcastsViewModel?>(
        stream: widget.presenter.viewModel,
        builder: (context, snapshot) {
          final viewModel = snapshot.data;
          if (viewModel == null) {
            return EmptyState(
              icon: 'lib/ui/assets/images/icon/clapperboard-play.svg',
              title: R.string.messageEmpty,
            );
          }
          if (!initializedTabBar) {
            _tabController.index = viewModel.broadcastDayPeriod.index;
            initializedTabBar = true;
          }
          final isEmpty = viewModel.showEmptyState == true;
          return isEmpty
              ? EmptyState(
                  icon: 'lib/ui/assets/images/icon/clapperboard-play.svg',
                  title: R.string.messageEmpty,
                )
              : ListView(
                  children: [
                    if (viewModel.currentVideo != null)
                      SizedBox(
                        height: 250,
                        child: YoutubeWebViewPlayer(
                          key: ValueKey(viewModel.currentVideo?.link ?? ''),
                          youtubeUrl: viewModel.currentVideo?.link ?? '',
                        ),
                      ),
                    if (viewModel.currentVideo != null)
                      VideoDetails(
                        presenter: widget.presenter,
                        viewModel: viewModel,
                      ),
                    DefaultTabController(
                      length: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: TabBar(
                              controller: _tabController,
                              indicatorColor: AppColors.primaryLight,
                              labelColor: AppColors.primaryLight,
                              unselectedLabelColor: AppColors.neutralLowDark,
                              indicatorSize: TabBarIndicatorSize.tab,
                              labelStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              unselectedLabelStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                              tabs: BroadcastDayPeriod.values
                                  .where((element) =>
                                      element != BroadcastDayPeriod.none)
                                  .map(
                                    (period) => Tab(
                                      text: period.tabTitle,
                                    ),
                                  )
                                  .toList(),
                              onTap: (value) {
                                final period = BroadcastDayPeriod.values[value];
                                final filters =
                                    viewModel.filtersByPeriod(period);
                                if (filters.isNotEmpty) {
                                  viewModel.setCurrentFilter(
                                    viewModel.currentFilter ?? filters[0],
                                    period,
                                  );
                                }
                                _tabController.index = value;
                                setState(() {});
                              },
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                _buildTabContent(
                                    viewModel, BroadcastDayPeriod.morning),
                                _buildTabContent(
                                    viewModel, BroadcastDayPeriod.afternoon),
                                _buildTabContent(
                                    viewModel, BroadcastDayPeriod.night),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }

  Widget _buildTabContent(
      BroadcastsViewModel viewModel, BroadcastDayPeriod period) {
    final filters = viewModel.filtersByPeriod(period);
    final hasOneItem = viewModel.hasVideoByPeriodAndCurrentLanguage(period);
    if (!hasOneItem) {
      return Center(
        child: EmptyState(
          icon: 'lib/ui/assets/images/icon/clapperboard-play.svg',
          title: R.string.messageEmpty,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.07,
          child: ListView.builder(
            itemCount: filters.length,
            itemBuilder: (context, index) {
              final filter = filters[index];
              final isSelectedFilter =
                  filter.language == viewModel.currentFilter?.language;
              return Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 12.0),
                child: FilterCostum(
                  text: filter.language.toUpperCase(),
                  backgroundColor: isSelectedFilter
                      ? AppColors.primaryLight
                      : AppColors.neutralLight,
                  textColor: isSelectedFilter
                      ? AppColors.white
                      : AppColors.primaryLight,
                  onTap: () {
                    widget.presenter.selectCurrentFilter(
                      filter: filter,
                      viewModel: viewModel,
                      broadcastDayPeriod: period,
                    );
                    setState(() {});
                  },
                ),
              );
            },
            scrollDirection: Axis.horizontal,
          ),
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: PreviousSection(
              viewModel: viewModel.broadCastByType(period),
              onTap: (broadcastViewModel) {
                if (broadcastViewModel != null) {
                  widget.presenter.selectCurrentPlayer(
                    broadcastViewModel: broadcastViewModel,
                    viewModel: viewModel,
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
