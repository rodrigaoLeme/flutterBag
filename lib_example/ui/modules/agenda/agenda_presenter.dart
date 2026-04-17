import '../../../domain/entities/agenda/agenda_entity.dart';
import '../../../presentation/mixins/loading_manager.dart';
import '../../mixins/mixins.dart';
import '../modules.dart';

abstract class AgendaPresenter {
  Stream<bool> get isSessionExpiredStream;
  Stream<NavigationData?> get navigateToStream;
  Stream<AgendaViewModel?> get viewModel;
  Stream<LoadingData?> get isLoadingStream;

  Future<void> loadData();
  void dispose();
  Future<AgendaEntity?> loadFavorites();
  Future<void> saveFavorites({
    required ScheduleViewModel event,
    required AgendaViewModel viewModel,
  });
  void selectCurrentFilter({
    required ScheduleFilter filter,
    required AgendaViewModel viewModel,
  });
  void goToEventDetails();
}
