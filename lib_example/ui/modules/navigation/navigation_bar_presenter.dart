import 'package:flutter/material.dart';

import '../../../presentation/presenters/navigation_bar/tab_bar_itens.dart';
import '../event_details/event_details_view_model.dart';

abstract class NavigationBarPresenter {
  ValueNotifier<TabBarItens?> get currentTab;
  ValueNotifier<int?> get reloadPage;
  PageController get pageController;
  Stream<EventDetailsViewModel?> get viewModel;

  void setCurrentTab({required TabBarItens tab});
  void clearReloadPage();
  Future<void> conviniendeInit();
  void reloadPageBy(int index);
}
