import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../data/models/agenda/remote_agenda_model.dart';
import '../../../domain/entities/agenda/agenda_entity.dart';
import '../../../domain/usecases/agenda/load_current_agenda.dart';
import '../../../domain/usecases/agenda/save_current_agenda.dart';
import '../../../domain/usecases/event/load_current_event.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../main/routes/routes_app.dart';
import '../../../ui/helpers/extensions/string_extension.dart';
import '../../../ui/mixins/navigation_data.dart';
import '../../../ui/modules/modules.dart';
import '../../mixins/mixins.dart';

class StreamAgendaPresenter
    with SessionManager, LoadingManager, NavigationManager, UIErrorManager
    implements AgendaPresenter {
  final LoadAgenda loadAgenda;
  final LoadCurrentEvent loadCurrentEvent;
  final LoadCurrentAgenda loadCurrentAgenda;
  final SaveCurrentAgenda saveCurrentAgenda;
  AgendaEntity? entity;
  ScheduleFilter? currentFilter;

  StreamAgendaPresenter({
    required this.loadAgenda,
    required this.loadCurrentEvent,
    required this.loadCurrentAgenda,
    required this.saveCurrentAgenda,
  });

  final StreamController<AgendaViewModel?> _viewModel =
      StreamController<AgendaViewModel?>.broadcast();
  @override
  Stream<AgendaViewModel?> get viewModel => _viewModel.stream;

  @override
  Future<void> loadData() async {
    try {
      isLoading = LoadingData(isLoading: true);

      final currentEvent = await loadCurrentEvent.load();
      final favoriteSchedule = await loadFavorites();
      loadAgenda
          .load(
              params: LoadScheduleParams(
                  eventSchedule: currentEvent?.externalId ?? ''))
          ?.listen(
        (document) async {
          try {
            entity = RemoteAgendaModel.fromDocument(document).toEntity();
            final scheduleViewModel = await ScheduleViewModelFactory.make(
              entity: entity,
              favorites: favoriteSchedule,
              currentFilter: currentFilter,
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
  void dispose() {
    Future.microtask(() {
      Modular.to.pushReplacementNamed(Modular.to.path, arguments: null);
    });
    _viewModel.close();
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
    required AgendaViewModel viewModel,
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
      } else {
        favoriteSchedule.schedule?.add(eventEntity);
        favoriteSchedule.schedule?.sort(
          (a, b) => (a.startTime?.toEnDate ?? DateTime.now())
              .compareTo(b.startTime?.toEnDate ?? DateTime.now()),
        );
      }
      final eventMap = favoriteSchedule.toJson();
      final json = jsonEncode(eventMap);
      await saveCurrentAgenda.save(
        params: SaveCurrentAgendaParams(
          eventId: currentEvent?.externalId ?? '',
          data: json,
        ),
      );
      final AgendaEntity favoriteScheduleFull =
          await loadFavorites() ?? AgendaEntity(schedule: []);
      await viewModel.setAsFavorite(
        event,
        entity,
        favoriteScheduleFull,
      );
      viewModel.setCurrentFilter(viewModel.currentFilter);
      currentFilter = viewModel.currentFilter;
      _viewModel.add(viewModel);
    } catch (error) {
      return;
    }
  }

  @override
  void selectCurrentFilter({
    required ScheduleFilter filter,
    required AgendaViewModel viewModel,
  }) {
    viewModel.setCurrentFilter(filter);
    _viewModel.add(viewModel);
  }

  @override
  void goToEventDetails() {
    navigateTo = NavigationData(
      route: Routes.eventDetails,
      clear: false,
    );
  }
}
