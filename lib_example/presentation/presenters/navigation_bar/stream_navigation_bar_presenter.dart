import 'dart:async';

import 'package:flutter/material.dart';

import '../../../data/models/event_details/remote_event_details_model.dart';
import '../../../domain/usecases/event/load_current_event.dart';
import '../../../domain/usecases/event_details.dart/load_event_details.dart';
import '../../../ui/modules/event_details/event_details_view_model.dart';
import '../../../ui/modules/navigation/navigation_bar_presenter.dart';
import '../../mixins/loading_manager.dart';
import 'tab_bar_itens.dart';

class StreamNavigationBarPresenter
    with LoadingManager
    implements NavigationBarPresenter {
  final ValueNotifier<TabBarItens?> _currentTab =
      ValueNotifier<TabBarItens?>(null);
  final PageController _pageController = PageController(initialPage: 1);
  final ValueNotifier<int?> _reloadPage = ValueNotifier<int?>(null);
  final LoadEventDetails loadEventDetails;
  final LoadCurrentEvent loadCurrentEvent;

  StreamNavigationBarPresenter({
    required this.loadCurrentEvent,
    required this.loadEventDetails,
  });

  final StreamController<EventDetailsViewModel?> _viewModel =
      StreamController<EventDetailsViewModel?>.broadcast();
  @override
  Stream<EventDetailsViewModel?> get viewModel => _viewModel.stream;

  @override
  PageController get pageController => _pageController;
  @override
  ValueNotifier<TabBarItens?> get currentTab => _currentTab;
  @override
  ValueNotifier<int?> get reloadPage => _reloadPage;

  @override
  void setCurrentTab({required TabBarItens tab}) {
    _currentTab.value = tab;
  }

  @override
  void clearReloadPage() {
    _reloadPage.value = null;
  }

  @override
  void reloadPageBy(int index) {
    _reloadPage.value = index;
  }

  @override
  Future<void> conviniendeInit() async {
    try {
      isLoading = LoadingData(isLoading: true);
      final currentEvent = await loadCurrentEvent.load();
      loadEventDetails
          .load(
        params: LoadEventDetailsParams(
          eventId: currentEvent?.externalId ?? '',
        ),
      )
          ?.listen(
        (document) async {
          try {
            final model = EventDetailsResultModel.fromDocument(document);
            final eventDetailsModel =
                await EventDetailsViewModelFactory.make(model.event);
            _viewModel.add(eventDetailsModel);
          } catch (e) {
            _viewModel.addError(e);
          } finally {
            isLoading = LoadingData(isLoading: false);
          }
        },
        onError: (error) {
          _viewModel.addError(error);
        },
      );
    } catch (error) {
      _viewModel.addError(error);
    }
  }
}
