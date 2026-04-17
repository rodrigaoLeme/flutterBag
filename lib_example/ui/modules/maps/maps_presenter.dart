import '../../../presentation/mixins/loading_manager.dart';
import '../event_details/event_details_view_model.dart';
import 'maps_view_model.dart';

abstract class MapPresenter {
  Stream<EventDetailsViewModel?> get viewModel;
  Stream<MapsViewModel?> get mapViewModel;
  Stream<LoadingData?> get isLoadingStream;
  Future<void> loadData();
  Future<void> loadMaps();
  void dispose();
}
