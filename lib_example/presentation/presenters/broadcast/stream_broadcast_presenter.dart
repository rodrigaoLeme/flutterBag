import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../data/models/agenda/remote_agenda_model.dart';
import '../../../data/models/broadcast/remote_broadcast_model.dart';
import '../../../domain/usecases/agenda/load_agenda.dart';
import '../../../domain/usecases/broadcast/load_broadcast.dart';
import '../../../domain/usecases/event/load_current_event.dart';
import '../../../domain/usecases/translation/load_current_translation.dart';
import '../../../ui/modules/agenda/agenda_view_model.dart';
import '../../../ui/modules/broadcast/broadcast_presenter.dart';
import '../../../ui/modules/broadcast/broadcast_view_model.dart';
import '../../mixins/mixins.dart';

class StreamBroadcastPresenter
    with SessionManager, LoadingManager, NavigationManager, UIErrorManager
    implements BroadcastPresenter {
  final LoadBroadcast loadBroadcast;
  final LoadCurrentEvent loadCurrentEvent;
  final LoadAgenda loadAgenda;

  final LoadCurrentTranslation loadCurrentTranslation;
  bool shouldReloadView = false;

  StreamBroadcastPresenter({
    required this.loadBroadcast,
    required this.loadCurrentEvent,
    required this.loadCurrentTranslation,
    required this.loadAgenda,
  });

  final StreamController<BroadcastsViewModel?> _viewModel =
      StreamController<BroadcastsViewModel?>.broadcast();
  @override
  Stream<BroadcastsViewModel?> get viewModel => _viewModel.stream;

  final StreamController<AgendaViewModel?> _agendaViewModel =
      StreamController<AgendaViewModel?>.broadcast();
  @override
  Stream<AgendaViewModel?> get agendaViewModel => _agendaViewModel.stream;

  final ValueNotifier<BroadcastsViewModel?> _broadcastLanguages =
      ValueNotifier<BroadcastsViewModel?>(null);
  @override
  ValueNotifier<BroadcastsViewModel?> get broadcastLanguages =>
      _broadcastLanguages;

  @override
  Future<void> loadData() async {
    try {
      isLoading = LoadingData(isLoading: true);
      final language = await loadCurrentTranslation.load();
      final currentEvent = await loadCurrentEvent.load();
      loadBroadcast
          .load(
              params:
                  LoadBroadcastParams(eventId: currentEvent?.externalId ?? ''))
          ?.listen(
        (document) async {
          try {
            final model =
                RemoteBroadcastModel.fromDocument(document).toEntity();
            final scheduleViewModel = await BroadcastsViewModelFactory.make(
              model,
              language,
            );
            _viewModel.add(scheduleViewModel);
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

  @override
  void selectCurrentFilter({
    required BroadcastFilter filter,
    required BroadcastsViewModel viewModel,
    required BroadcastDayPeriod broadcastDayPeriod,
  }) {
    viewModel.setCurrentFilter(filter, broadcastDayPeriod);
    _viewModel.add(viewModel);
  }

  @override
  void dispose() {
    _viewModel.close();
  }

  @override
  Future<void> chooseLenguage({
    required BroadcastLanguages language,
    required BroadcastsViewModel viewModel,
  }) async {
    try {
      viewModel.setCurrentLanguage(language);
      languageBottomSheetInit(viewModel);
      _viewModel.add(viewModel);
    } catch (e) {
      return;
    }
  }

  @override
  void selectCurrentPlayer({
    required BroadcastViewModel broadcastViewModel,
    required BroadcastsViewModel viewModel,
  }) {
    viewModel.setCurrentVideo(broadcastViewModel);
    _viewModel.add(viewModel);
  }

  @override
  Future<void> fetchAgenda() async {
    try {
      final currentEvent = await loadCurrentEvent.load();
      loadAgenda
          .load(
              params: LoadScheduleParams(
                  eventSchedule: currentEvent?.externalId ?? ''))
          ?.listen(
        (document) async {
          try {
            final model = RemoteAgendaModel.fromDocument(document);
            final scheduleViewModel = await ScheduleViewModelFactory.make(
              entity: model.toEntity(),
              favorites: null,
            );
            _agendaViewModel.add(scheduleViewModel);
          } catch (e) {
            _agendaViewModel.add(null);
          }
        },
        onError: (error) {
          _agendaViewModel.add(null);
        },
      );
    } catch (error) {
      _agendaViewModel.add(null);
    }
  }

  @override
  void languageBottomSheetInit(BroadcastsViewModel viewModel) {
    _broadcastLanguages.value = BroadcastsViewModel(
      broadcasts: viewModel.broadcasts,
      filters: viewModel.filters,
      currentFilter: viewModel.currentFilter,
      language: viewModel.language,
      currentVideo: viewModel.currentVideo,
      broadcastDayPeriod: viewModel.broadcastDayPeriod,
    );
  }
}
