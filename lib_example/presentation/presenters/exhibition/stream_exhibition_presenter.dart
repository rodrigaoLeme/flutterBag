import 'dart:async';
import 'dart:convert';

import '../../../data/models/exhibition/remote_exhibition_model.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/event/load_current_event.dart';
import '../../../domain/usecases/exhibition/load_current_exhibitor.dart';
import '../../../domain/usecases/exhibition/load_exhibition.dart';
import '../../../domain/usecases/exhibition/save_current_exhibition.dart';
import '../../../ui/modules/modules.dart';
import '../../mixins/mixins.dart';

class StreamExhibitionPresenter
    with SessionManager, LoadingManager, NavigationManager, UIErrorManager
    implements ExhibitionPresenter {
  final LoadExhibition loadExhibition;
  final LoadCurrentEvent loadCurrentEvent;
  final SaveCurrentExhibition localSaveCurrentExhibitor;
  final LoadCurrentExhibitor loadCurrentExhibitor;
  ExhibitionsViewModel? _currentViewModel;

  StreamExhibitionPresenter({
    required this.loadExhibition,
    required this.loadCurrentEvent,
    required this.localSaveCurrentExhibitor,
    required this.loadCurrentExhibitor,
  });

  final StreamController<ExhibitionsViewModel?> _exhibitionViewModel =
      StreamController<ExhibitionsViewModel?>.broadcast();
  @override
  Stream<ExhibitionsViewModel?> get exhibitionViewModel =>
      _exhibitionViewModel.stream;
  ExhibitionsViewModel viewModel = ExhibitionsViewModel(
      exhibitions: [],
      favoritesExhibition: [],
      exhibitionGroups: [],
      exhibitionDivisionGroups: []);

  @override
  Future<void> loadExhibitions() async {
    try {
      final event = await loadCurrentEvent.load();
      final favorites = await loadFavorites();

      loadExhibition
          .load(params: LoadExhibitionParams(eventId: event?.externalId ?? ''))
          ?.listen(
        (document) async {
          try {
            final model = RemoteExhibitionModel.fromDocument(document);
            final exhibitionViewModel = await ExhibitionViewModelFactory.make(
              model: model,
              favorites: favorites,
            );
            _currentViewModel = exhibitionViewModel;
            _exhibitionViewModel.add(exhibitionViewModel);
          } catch (e) {
            _exhibitionViewModel.addError(e);
          }
        },
        onError: (error) {
          _exhibitionViewModel.addError(error);
        },
      );
    } catch (error) {
      _exhibitionViewModel.addError(error);
    }
  }

  @override
  Future<ExhibitionViewModel> savedFavorites({
    required ExhibitionViewModel exhibitor,
  }) async {
    try {
      final currentEvent = await loadCurrentEvent.load();
      final exhibitorEntity = exhibitor.toEntity();
      final ExhibitionEntity favoriteExhibitor =
          await loadFavorites() ?? ExhibitionEntity(exhibitor: []);

      final isAlreadyFavorite = favoriteExhibitor.exhibitor?.any(
            (element) => element.externalId == exhibitorEntity.externalId,
          ) ??
          false;

      if (isAlreadyFavorite) {
        favoriteExhibitor.exhibitor
            ?.removeWhere((e) => e.externalId == exhibitorEntity.externalId);
      } else {
        favoriteExhibitor.exhibitor?.add(exhibitorEntity);
      }

      final json = jsonEncode(favoriteExhibitor.toJson());
      await localSaveCurrentExhibitor.save(
        params: SaveCurrentExhibitionParams(
          eventId: currentEvent?.externalId ?? '',
          data: json,
        ),
      );
      exhibitor.setIsFavorite();

      final currentViewModel = _currentViewModel;
      if (currentViewModel == null) return exhibitor;
      final index = currentViewModel.exhibitions.indexWhere(
        (e) => e.id == exhibitor.id,
      );

      if (index != -1) {
        currentViewModel.exhibitions[index] = exhibitor;
      }
      currentViewModel.favoritesExhibition = currentViewModel.exhibitions
          .where((e) => e.isFavorite ?? false)
          .toList();

      currentViewModel.favoritesExhibitionFiltered = currentViewModel
          .filteredExhibitions
          .where((e) => e.isFavorite ?? false)
          .toList();
      _exhibitionViewModel.add(currentViewModel);

      return exhibitor;
    } catch (error) {
      return exhibitor;
    }
  }

  Future<ExhibitionEntity?> loadFavorites() async {
    try {
      final currentEvent = await loadCurrentEvent.load();
      return await loadCurrentExhibitor.load(
        params: LoadCurrentExhibitorParams(
          eventId: currentEvent?.externalId ?? '',
        ),
      );
    } catch (error) {
      return null;
    }
  }

  @override
  void dispose() {
    _exhibitionViewModel.close();
  }

  @override
  void clearFilter(ExhibitionsViewModel viewModel) {
    viewModel.clearFilter();
    _exhibitionViewModel.add(viewModel);
  }

  @override
  void filterBy(String text, ExhibitionsViewModel viewModel) {
    viewModel.filterBy(text);
    _exhibitionViewModel.add(viewModel);
  }

  @override
  void setCurrentFilter(
      ExhibitionGroup filter, ExhibitionsViewModel viewModel) {
    viewModel.setCurrentFilter(filter);
    _exhibitionViewModel.add(viewModel);
  }

  @override
  void setCurrentDivisionFilter(
      ExhibitionGroup filter, ExhibitionsViewModel viewModel) {
    viewModel.setCurrentDivisionFilter(filter);
    _exhibitionViewModel.add(viewModel);
  }

  @override
  void showLoadingFlow({required bool loading}) {
    isLoading = LoadingData(isLoading: loading);
  }
}
