import 'dart:convert';

import '../../../domain/entities/food/food_entity.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/food/load_current_external_food.dart';
import '../../cache/cache.dart';
import '../../models/food/remote_food_model.dart';

class LocalLoadCurrentExternalFood implements LoadCurrentExternalFood {
  final SharedPreferencesStorage sharedPreferencesStorage;

  LocalLoadCurrentExternalFood({
    required this.sharedPreferencesStorage,
  });

  @override
  Future<FoodResultEntity?> load({
    required LoadCurrentExternalFoodParams params,
  }) async {
    try {
      final key = '${SecureStorageKey.favoriteFood}_${params.eventId}';
      final data = await sharedPreferencesStorage.fetch(key);
      if (data == null) throw DomainError.expiredSession;
      final model = RemoteResultFoodModel.fromJson(jsonDecode(data)).toEntity();
      return model;
    } catch (error) {
      return null;
    }
  }
}
