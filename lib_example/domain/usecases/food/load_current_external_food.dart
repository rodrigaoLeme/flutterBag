import '../../entities/food/food_entity.dart';

abstract class LoadCurrentExternalFood {
  Future<FoodResultEntity?> load({
    required LoadCurrentExternalFoodParams params,
  });
}

class LoadCurrentExternalFoodParams {
  final String eventId;
  LoadCurrentExternalFoodParams({
    required this.eventId,
  });
}
