import '../../../domain/entities/agenda/agenda_entity.dart';
import '../../../presentation/mixins/loading_manager.dart';
import '../../mixins/mixins.dart';
import '../agenda/agenda_view_model.dart';
import 'event_details_view_model.dart';

abstract class EventDetailsPresenter {
  Stream<bool> get isSessionExpiredStream;
  Stream<NavigationData?> get navigateToStream;

  Stream<EventDetailsViewModel?> get viewModel;
  Stream<ScheduleViewModel?> get scheduleViewModel;
  Stream<LoadingData?> get isLoadingStream;
  Future<void> convinienceInit();
  void dispose();
  void goToGetInLine();

  Future<AgendaEntity?> loadFavorites();
  Future<void> saveFavorites({
    required ScheduleViewModel event,
  });
  Future<void> loadData();
}
