import '../../mixins/mixins.dart';
import 'food_view_model.dart';

abstract class FoodPresenter {
  Stream<bool> get isSessionExpiredStream;
  Stream<NavigationData?> get navigateToStream;
  Stream<FoodViewModel?> get viewModel;

  Future<void> fetchInternalFood();
  Future<void> fetchExternalFood();
  void dispose();
  Future<ExternalFoodViewModel> saveFavorites({
    required ExternalFoodViewModel food,
  });
  void clearFilter(FoodViewModel viewModel);
  FoodViewModel setCurrentFilter(
    ExternalFoodFilter filter,
    FoodViewModel viewModel,
    bool isActive,
    int index,
    ExternalFilterType type,
    bool isFavorite,
  );
}
