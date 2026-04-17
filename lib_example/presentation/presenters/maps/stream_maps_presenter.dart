import 'dart:async';

import '../../../data/models/event_details/remote_event_details_model.dart';
import '../../../data/models/map/remote_map_model.dart';
import '../../../domain/usecases/event/load_current_event.dart';
import '../../../domain/usecases/event_details.dart/event_details.dart';
import '../../../domain/usecases/map/load_map.dart';
import '../../../ui/modules/event_details/event_details_view_model.dart';
import '../../../ui/modules/maps/maps_presenter.dart';
import '../../../ui/modules/maps/maps_view_model.dart';
import '../../mixins/loading_manager.dart';
import '../../mixins/navigation_manager.dart';
import '../../mixins/session_manager.dart';
import '../../mixins/ui_error_manager.dart';

class StreamMapPresenter
    with SessionManager, LoadingManager, NavigationManager, UIErrorManager
    implements MapPresenter {
  final LoadMap loadMap;
  final LoadCurrentEvent loadCurrentEvent;
  final LoadEventDetails loadEventDetails;

  StreamMapPresenter({
    required this.loadMap,
    required this.loadCurrentEvent,
    required this.loadEventDetails,
  });

  final StreamController<EventDetailsViewModel?> _viewModel =
      StreamController<EventDetailsViewModel?>.broadcast();
  @override
  Stream<EventDetailsViewModel?> get viewModel => _viewModel.stream;

  final StreamController<MapsViewModel?> _mapsViewModel =
      StreamController<MapsViewModel?>.broadcast();
  @override
  Stream<MapsViewModel?> get mapViewModel => _mapsViewModel.stream;

  @override
  void dispose() {
    _viewModel.close();
  }

  @override
  Future<void> loadMaps() async {
    try {
      isLoading = LoadingData(isLoading: true);
      final currentEvent = await loadCurrentEvent.load();
      loadMap
          .load(
        params: LoadMapParams(
          eventId: currentEvent?.externalId ?? '',
        ),
      )
          ?.listen(
        (document) async {
          try {
            final model = RemoteMapModel.fromDocument(document);
            final maps = await MapsViewModelFactory.make(model);
            _mapsViewModel.add(maps);
          } catch (e) {
            _mapsViewModel.addError(e);
          } finally {
            isLoading = LoadingData(isLoading: false);
          }
        },
        onError: (error) {
          _mapsViewModel.addError(error);
        },
      );
    } catch (error) {
      _mapsViewModel.addError(error);
    }
  }

  @override
  Future<void> loadData() async {
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
