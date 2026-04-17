import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../data/models/food/remote_food_model.dart';
import '../../../data/models/food_internal/remote_food_internal_model.dart';
import '../../../domain/entities/food/food_entity.dart';
import '../../../domain/usecases/event/load_current_event.dart';
import '../../../domain/usecases/food/load_current_external_food.dart';
import '../../../domain/usecases/food/load_external_food.dart';
import '../../../domain/usecases/food/load_internal_food.dart';
import '../../../domain/usecases/food/save_current_external_food.dart';
import '../../../ui/modules/dashboard/section_view_model.dart';
import '../../../ui/modules/food/food_presenter.dart';
import '../../../ui/modules/food/food_view_model.dart';
import '../../mixins/mixins.dart';

class StreamFoodPresenter
    with SessionManager, LoadingManager, NavigationManager, UIErrorManager
    implements FoodPresenter {
  final LoadExternalFood loadExternalFood;
  final LoadCurrentEvent loadCurrentEvent;
  final LoadInternalFood loadInternalFood;
  final LoadCurrentExternalFood loadCurrentExternalFood;
  final SaveCurrentExternalFood localSaveCurrentFood;
  final SectionType sectionType;

  final StreamController<FoodViewModel?> _viewModel =
      StreamController<FoodViewModel?>.broadcast();
  @override
  Stream<FoodViewModel?> get viewModel => _viewModel.stream;
  FoodViewModel foodViewModel = FoodViewModel(
    externalFood: [],
    internalFood: [],
    favoreitesExternalFood: [],
    type: null,
    externalFoodFilter: ExternalFoodFilter(),
  );

  StreamFoodPresenter({
    required this.loadExternalFood,
    required this.loadInternalFood,
    required this.loadCurrentEvent,
    required this.loadCurrentExternalFood,
    required this.localSaveCurrentFood,
    required this.sectionType,
  });

  @override
  Future<void> fetchExternalFood() async {
    try {
      final currentEvent = await loadCurrentEvent.load();
      final favorites = await loadCurrentExternalFood.load(
        params: LoadCurrentExternalFoodParams(
          eventId: currentEvent?.externalId ?? '',
        ),
      );
      loadExternalFood
          .load(
              params: LoadExternalFoodParams(
        eventId: currentEvent?.externalId ?? '',
      ))
          ?.listen(
        (document) async {
          try {
            final model = RemoteResultFoodModel.fromDocument(document);
            final newViewModel = await ExternalFoodListViewModelFactory.make(
              model: model,
              favorites: favorites,
            );
            foodViewModel.externalFood = newViewModel.externalFood;
            foodViewModel.favoreitesExternalFood =
                newViewModel.favoreitesExternalFood;
            foodViewModel.externalFoodFilter = newViewModel.externalFoodFilter;
            _viewModel.add(
              FoodViewModel(
                externalFood: foodViewModel.externalFood,
                internalFood: foodViewModel.internalFood,
                favoreitesExternalFood: foodViewModel.favoreitesExternalFood,
                type: sectionType,
                externalFoodFilter: foodViewModel.externalFoodFilter,
              ),
            );
          } catch (e) {
            _viewModel.addError(e);
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
  Future<void> fetchInternalFood() async {
    try {
      final currentEvent = await loadCurrentEvent.load();

      loadInternalFood
          .load(
              params: LoadInternalFoodParams(
        eventId: currentEvent?.externalId ?? '',
      ))
          ?.listen(
        (document) async {
          try {
            final model = RemoteResultFoodInternalModel.fromDocument(document);
            final newViewModel = await ExternalFoodListViewModelFactory.make(
              internal: model,
            );
            foodViewModel.internalFood = newViewModel.internalFood;
            _viewModel.add(
              FoodViewModel(
                externalFood: foodViewModel.externalFood,
                internalFood: foodViewModel.internalFood,
                favoreitesExternalFood: foodViewModel.favoreitesExternalFood,
                type: sectionType,
                externalFoodFilter: foodViewModel.externalFoodFilter,
              ),
            );
          } catch (e) {
            _viewModel.addError(e);
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
  Future<ExternalFoodViewModel> saveFavorites({
    required ExternalFoodViewModel food,
  }) async {
    try {
      final currentEvent = await loadCurrentEvent.load();
      final eventEntity = food.toEntity();
      final FoodResultEntity favoriteFood =
          await loadFavorites() ?? FoodResultEntity(foodExternal: []);
      if (favoriteFood.foodExternal?.firstWhereOrNull(
              (element) => element.externalId == eventEntity.externalId) !=
          null) {
        favoriteFood.foodExternal?.removeWhere(
            (element) => element.externalId == eventEntity.externalId);
      } else {
        favoriteFood.foodExternal?.add(eventEntity);
      }
      final eventMap = favoriteFood.toJson();
      final json = jsonEncode(eventMap);
      await localSaveCurrentFood.save(
          params: SaveCurrentExternalFoodParams(
              eventId: currentEvent?.externalId ?? '', data: json));
      await fetchExternalFood();
      food.setIsFavorite();
      return food;
    } catch (error) {
      return food;
    }
  }

  Future<FoodResultEntity?> loadFavorites() async {
    try {
      final currentEvent = await loadCurrentEvent.load();
      return await loadCurrentExternalFood.load(
        params: LoadCurrentExternalFoodParams(
          eventId: currentEvent?.externalId ?? '',
        ),
      );
    } catch (error) {
      return null;
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
  void clearFilter(FoodViewModel viewModel) {
    viewModel.clearFilter();
    _viewModel.add(viewModel);
  }

  @override
  FoodViewModel setCurrentFilter(
      ExternalFoodFilter filter,
      FoodViewModel viewModel,
      bool isActive,
      int index,
      ExternalFilterType type,
      bool isFavorite) {
    filter.setIsActive(type, isActive, index);
    viewModel.setCurrentFilter(filter, isFavorite);
    _viewModel.add(viewModel);
    return viewModel;
  }
}
