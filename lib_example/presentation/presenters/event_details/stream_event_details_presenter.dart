import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../domain/entities/agenda/agenda_entity.dart';
import '../../../domain/usecases/agenda/load_current_agenda.dart';
import '../../../domain/usecases/agenda/save_current_agenda.dart';
import '../../../domain/usecases/event/load_current_event.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../main/routes/routes.dart';
import '../../../ui/mixins/navigation_data.dart';
import '../../../ui/modules/event_details/event_details_view_model.dart';
import '../../../ui/modules/modules.dart';
import '../../mixins/mixins.dart';

class StreamEventDetailsPresenter
    with SessionManager, LoadingManager, NavigationManager, UIErrorManager
    implements EventDetailsPresenter {
  LoadEventDetails loadEventDetails;
  LoadCurrentEvent loadCurrentEvent;
  final LoadCurrentAgenda loadCurrentAgenda;
  final SaveCurrentAgenda saveCurrentAgenda;

  StreamEventDetailsPresenter({
    required this.loadCurrentEvent,
    required this.loadEventDetails,
    required this.loadCurrentAgenda,
    required this.saveCurrentAgenda,
  });

  final StreamController<EventDetailsViewModel?> _viewModel =
      StreamController<EventDetailsViewModel?>.broadcast();
  @override
  Stream<EventDetailsViewModel?> get viewModel => _viewModel.stream;

  final StreamController<ScheduleViewModel?> _scheduleViewModel =
      StreamController<ScheduleViewModel?>.broadcast();
  @override
  Stream<ScheduleViewModel?> get scheduleViewModel => _scheduleViewModel.stream;

  @override
  Future<void> convinienceInit() async {
    try {
      await Future.delayed(const Duration(microseconds: 100));
      final detailsViewModel = Modular.args.data as ScheduleViewModel;
      _scheduleViewModel.add(detailsViewModel);
    } catch (error) {
      _scheduleViewModel.addError(error);
    }
  }

  @override
  void dispose() {
    _viewModel.close();
  }

  @override
  void goToGetInLine() {
    navigateTo = NavigationData(route: Routes.getInLine, clear: false);
  }

  @override
  Future<AgendaEntity?> loadFavorites() async {
    try {
      final currentEvent = await loadCurrentEvent.load();
      return await loadCurrentAgenda.load(
        params: LoadCurrentAgendaParams(
          eventId: currentEvent?.externalId ?? '',
        ),
      );
    } catch (error) {
      return null;
    }
  }

  @override
  Future<void> saveFavorites({
    required ScheduleViewModel event,
  }) async {
    try {
      final currentEvent = await loadCurrentEvent.load();
      final eventEntity = event.toEntity();
      final AgendaEntity favoriteSchedule =
          await loadFavorites() ?? AgendaEntity(schedule: []);
      if (favoriteSchedule.schedule?.firstWhereOrNull(
              (element) => element.externalId == eventEntity.externalId) !=
          null) {
        favoriteSchedule.schedule?.removeWhere(
            (element) => element.externalId == eventEntity.externalId);
        event.setFavorite(false);
      } else {
        favoriteSchedule.schedule?.add(eventEntity);
        event.setFavorite(true);
      }
      final eventMap = favoriteSchedule.toJson();
      final json = jsonEncode(eventMap);
      await saveCurrentAgenda.save(
        params: SaveCurrentAgendaParams(
          eventId: currentEvent?.externalId ?? '',
          data: json,
        ),
      );
      _scheduleViewModel.add(event);
    } catch (error) {
      return;
    }
  }

  @override
  Future<void> loadData() {
    throw UnimplementedError();
  }
}
