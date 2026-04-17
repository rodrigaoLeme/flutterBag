import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';

import '../../../main/factories/pages/agenda/agenda_page_factory.dart';
import '../../../main/factories/pages/exhibition/exhibition_page_factory.dart';
import '../../../main/factories/pages/menu/menu_page_factory.dart';
import '../../../main/factories/pages/pages.dart';
import '../../../presentation/presenters/navigation_bar/tab_bar_itens.dart';
import '../../../share/utils/app_color.dart';
import '../../helpers/i18n/resources.dart';
import '../event_details/event_details_view_model.dart';
import '../maps/map_by_pdf.dart';
import 'navigation_bar_controller.dart';
import 'navigation_bar_presenter.dart';

class NavigationBarPage extends StatefulWidget {
  final NavigationBarPresenter presenter;
  const NavigationBarPage({
    super.key,
    required this.presenter,
  });

  @override
  State<NavigationBarPage> createState() => NavBarPageState();
}

class NavBarPageState extends State<NavigationBarPage> {
  final NavigationBarController controller = NavigationBarController();
  final presenter = Modular.get<NavigationBarPresenter>();
  int _currentIndex = TabBarItens.home.value;

  Widget _buildPage(
    int index,
    List<TabBarItens> items,
    String? eventMap,
  ) {
    final tabItem = TabBarItens.fromIndex(index, eventMap?.isEmpty == true);

    switch (tabItem) {
      case TabBarItens.home:
        return makeDashboardPage();
      case TabBarItens.schedule:
        return makeAgendaPage();
      case TabBarItens.map:
        return PdfViewerPage(
          url: eventMap ?? '',
          title: R.string.mapsLabel,
        );
      case TabBarItens.exhibitions:
        return makeExhibitionPage();
      case TabBarItens.more:
        return makeMenuPage();
    }
  }

  @override
  void initState() {
    widget.presenter.conviniendeInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EventDetailsViewModel?>(
        stream: widget.presenter.viewModel,
        builder: (context, eventDetails) {
          if (eventDetails.data == null &&
              eventDetails.connectionState == ConnectionState.waiting) {
            return const SizedBox.shrink();
          }
          final showMap = eventDetails.data?.eventMap?.isNotEmpty == true;
          var items = List.of(TabBarItens.values);

          if (!showMap) {
            items.removeWhere(
                (element) => element.value == TabBarItens.map.value);
          }

          return ValueListenableBuilder(
            valueListenable: widget.presenter.currentTab,
            builder: (context, snapshot, _) {
              _currentIndex =
                  snapshot?.getIndex(!showMap) ?? TabBarItens.home.value;
              return Scaffold(
                body: IndexedStack(
                  index: _currentIndex,
                  children: List.generate(
                    items.length,
                    (index) => _currentIndex == index
                        ? _buildPage(index, items, eventDetails.data?.eventMap)
                        : Container(),
                  ),
                ),
                bottomNavigationBar: Theme(
                  data: Theme.of(context).copyWith(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                  child: BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    currentIndex: _currentIndex,
                    onTap: (index) {
                      widget.presenter.setCurrentTab(tab: items[index]);
                      controller.changeTabIndex(index);
                    },
                    backgroundColor: AppColors.white,
                    selectedItemColor: AppColors.primaryLight,
                    unselectedItemColor: AppColors.primaryLight,
                    showUnselectedLabels: true,
                    showSelectedLabels: true,
                    enableFeedback: false,
                    selectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 12.0,
                    ),
                    items: [
                      _buildBottomNavigationBarItem(
                        iconPath: 'lib/ui/assets/images/icon/home_light.svg',
                        activeIconPath:
                            'lib/ui/assets/images/icon/home_solid.svg',
                        isSelected: _currentIndex == TabBarItens.home.value,
                        title: R.string.home,
                      ),
                      _buildBottomNavigationBarItem(
                        iconPath:
                            'lib/ui/assets/images/icon/schedule_light.svg',
                        activeIconPath:
                            'lib/ui/assets/images/icon/schedule_solid.svg',
                        isSelected: _currentIndex == TabBarItens.schedule.value,
                        title: R.string.scheduleLabel,
                      ),
                      if (showMap)
                        _buildBottomNavigationBarItem(
                          iconPath:
                              'lib/ui/assets/images/icon/location_light.svg',
                          activeIconPath:
                              'lib/ui/assets/images/icon/location_solid.svg',
                          isSelected: _currentIndex == TabBarItens.map.value,
                          title: R.string.map,
                        ),
                      _buildBottomNavigationBarItem(
                        iconPath:
                            'lib/ui/assets/images/icon/exhibition_light.svg',
                        activeIconPath:
                            'lib/ui/assets/images/icon/exhibition_solid.svg',
                        isSelected:
                            _currentIndex == TabBarItens.exhibitions.value,
                        title: R.string.exhibitionsLabel,
                      ),
                      _buildBottomNavigationBarItem(
                        iconPath: 'lib/ui/assets/images/icon/more_light.svg',
                        activeIconPath:
                            'lib/ui/assets/images/icon/more_solid.svg',
                        isSelected: _currentIndex == TabBarItens.more.value,
                        title: R.string.more,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem({
    required String iconPath,
    required String activeIconPath,
    required bool isSelected,
    required String title,
  }) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 6.0),
        child: SizedBox(
          height: 24,
          width: 24,
          child: SvgPicture.asset(
            iconPath,
            fit: BoxFit.contain,
            color: AppColors.primaryLight,
          ),
        ),
      ),
      activeIcon: Padding(
        padding: const EdgeInsets.only(bottom: 6.0),
        child: SizedBox(
          height: 24,
          width: 24,
          child: SvgPicture.asset(
            activeIconPath,
            fit: BoxFit.contain,
            color: AppColors.primaryLight,
          ),
        ),
      ),
      label: title,
    );
  }
}
