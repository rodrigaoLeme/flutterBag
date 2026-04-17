import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:open_filex/open_filex.dart';

import '../../../infra/download/file_download.dart';
import '../../../infra/firebase/feature_flag.dart';
import '../../../presentation/mixins/push_fullscreen_manager.dart';
import '../../../share/utils/app_color.dart';
import '../../components/empty_state.dart';
import '../../components/enum/design_system_enums.dart';
import '../../components/gc_text.dart';
import '../../components/input_placeholder.dart';
import '../../components/themes/gc_styles.dart';
import '../../helpers/extensions/string_extension.dart';
import '../../helpers/helpers.dart';
import '../../mixins/loading_manager.dart';
import '../../mixins/push_fullscreen_manager.dart';
import '../food/components/filter_costum.dart';
import '../modules.dart';
import 'components/exhibition_main_section.dart';
import 'components/filter_exhibitions_modal.dart';

class ExhibitionPage extends StatefulWidget {
  final ExhibitionPresenter presenter;

  const ExhibitionPage({
    super.key,
    required this.presenter,
  });

  @override
  ExhibitionPageState createState() => ExhibitionPageState();
}

class ExhibitionPageState extends State<ExhibitionPage> with LoadingManager {
  final ValueNotifier<int> _selectedIndex = ValueNotifier<int>(0);
  bool isDownloading = false;
  String _exhibitorsScheduleFlag = '';
  Future<String?>? _exhibitorsScheduleFuture;
  @override
  void initState() {
    PushFullscreenManagerListener.handleFullScreen(
        context, PushFullscreenManager().isShowingStream);
    widget.presenter.loadExhibitions();
    handleLoading(context, widget.presenter.isLoadingStream);
    _exhibitorsScheduleFlag = FeatureFlags().getfeatureExhibitorsSchedule();
    if (_exhibitorsScheduleFlag != '') {
      _exhibitorsScheduleFuture = _exhibitorsScheduleFlag.translateSections();
    }
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
        title: Align(
          alignment: Alignment.topLeft,
          child: GcText(
            text: R.string.exhibitionLabel,
            textSize: GcTextSizeEnum.h3w5,
            textStyleEnum: GcTextStyleEnum.semibold,
            color: AppColors.white,
            gcStyles: GcStyles.poppins,
          ),
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: StreamBuilder<ExhibitionsViewModel?>(
          stream: widget.presenter.exhibitionViewModel,
          builder: (context, snapshot) {
            final viewModel = snapshot.data;
            if (viewModel == null) {
              return EmptyState(
                icon: 'lib/ui/assets/images/icon/house-blank.svg',
                title: R.string.messageEmpty,
              );
            }
            return Column(
              children: [
                ValueListenableBuilder(
                  valueListenable: _selectedIndex,
                  builder: (context, snapshot, _) {
                    return Container(
                      height: 49,
                      color: AppColors.white,
                      child: TabBar(
                        indicatorColor: AppColors.primaryLight,
                        labelColor: AppColors.black,
                        unselectedLabelColor: AppColors.onSecundaryContainer,
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        tabs: [
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 16.0, left: 16.0),
                            child: Tab(
                              child: Center(
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: snapshot == 0
                                          ? FontWeight.w700
                                          : FontWeight.w400,
                                      color: snapshot == 0
                                          ? AppColors.primaryLight
                                          : AppColors.black,
                                    ),
                                    children: [
                                      TextSpan(text: R.string.allLabel),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 16.0, left: 16.0),
                            child: Tab(
                              child: Center(
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: snapshot == 1
                                          ? FontWeight.w700
                                          : FontWeight.w400,
                                      color: snapshot == 1
                                          ? AppColors.primaryLight
                                          : AppColors.black,
                                    ),
                                    children: [
                                      TextSpan(text: R.string.favoritesLabel),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                        onTap: (index) {
                          _selectedIndex.value = index;
                        },
                      ),
                    );
                  },
                ),
                if (_exhibitorsScheduleFlag != '')
                  FutureBuilder(
                      future: _exhibitorsScheduleFuture,
                      builder: (context, asyncSnapshot) {
                        if (asyncSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox.shrink();
                        }
                        return Container(
                          padding: const EdgeInsets.only(top: 8),
                          height: 48,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'lib/ui/assets/images/icon/clock_icon.svg',
                                height: 16,
                                width: 16,
                                color: AppColors.neutralLowDark,
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              GcText(
                                text: asyncSnapshot.data ?? '',
                                gcStyles: GcStyles.poppins,
                                textSize: GcTextSizeEnum.callout,
                                textStyleEnum: GcTextStyleEnum.semibold,
                                color: AppColors.neutralLowDark,
                              ),
                            ],
                          ),
                        );
                      }),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                  child: InputPlaceholder(
                    onChanged: (text) {
                      widget.presenter.filterBy(text, viewModel);
                    },
                    hint: R.string.searchExhibitor,
                    iconLeading: const Icon(
                      Icons.search,
                      color: AppColors.neutralLowMedium,
                    ),
                    style: const TextStyle(
                      color: AppColors.neutralHigh,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                    ),
                    icon: const Icon(
                      Icons.close,
                      size: 16,
                      color: AppColors.neutralLowMedium,
                    ),
                  ),
                ),
                SizedBox(
                  height: 42,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: viewModel.selectedDivisionGroups.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: FilterCostum(
                            text: R.string.filtersLabel,
                            customIcon: SvgPicture.asset(
                              'lib/ui/assets/images/icon/filter-list-regular.svg',
                              height: 16,
                              width: 16,
                              color: AppColors.white,
                            ),
                            backgroundColor: AppColors.primaryLight,
                            textColor: AppColors.white,
                            onTap: () {
                              _selectedIndex.value = 0;
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) => FilterExhibitionsModal(
                                  presenter: widget.presenter,
                                  viewModel: viewModel,
                                ),
                              );
                            },
                          ),
                        );
                      }

                      final group = viewModel.selectedDivisionGroups[index - 1];
                      return Padding(
                        padding: EdgeInsets.only(
                          left: 8,
                          right:
                              viewModel.selectedDivisionGroups.length == index
                                  ? 16
                                  : 0,
                        ),
                        child: FilterCostum(
                          icon: Icons.close,
                          text: group.description,
                          backgroundColor: !group.isSelected
                              ? AppColors.neutralLight
                              : AppColors.primaryLight,
                          textColor: group.isSelected
                              ? AppColors.white
                              : AppColors.primaryLight,
                          onTap: () {
                            widget.presenter.setCurrentFilter(group, viewModel);
                          },
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      viewModel.filteredExhibitions.isEmpty
                          ? Center(
                              child: EmptyState(
                                icon: viewModel.isSearching
                                    ? 'lib/ui/assets/images/icon/lupa.svg'
                                    : 'lib/ui/assets/images/icon/house-blank.svg',
                                title: viewModel.isSearching
                                    ? R.string.messageEmptyFilterExhibitor
                                    : R.string.noResults,
                              ),
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: ExhibitionMainSection(
                                exhibitions: viewModel.filteredExhibitions,
                                onFavoriteToggle: (exhibitor) async {
                                  return await widget.presenter
                                      .savedFavorites(exhibitor: exhibitor);
                                },
                                onTapDownload: onTapDownload,
                              ),
                            ),
                      viewModel.favoritesExhibitionFiltered.isEmpty
                          ? Center(
                              child: EmptyState(
                                icon:
                                    'lib/ui/assets/images/icon/cards_star.svg',
                                title: R.string.messageEmptyFilterExhibitor,
                              ),
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: ExhibitionMainSection(
                                exhibitions:
                                    viewModel.favoritesExhibitionFiltered,
                                onFavoriteToggle: (exhibitor) async {
                                  return await widget.presenter
                                      .savedFavorites(exhibitor: exhibitor);
                                },
                                onTapDownload: onTapDownload,
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
    } finally {
      isDownloading = false;
      widget.presenter.showLoadingFlow(loading: false);
    }
  }
}
