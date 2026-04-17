import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/food/save_current_external_food.dart';
import '../../cache/cache.dart';

class LocalSaveCurrentExternalFood implements SaveCurrentExternalFood {
  final SharedPreferencesStorage sharedPreferencesStorage;

  LocalSaveCurrentExternalFood({
    required this.sharedPreferencesStorage,
  });

  @override
  Future<void> save({required SaveCurrentExternalFoodParams params}) async {
    try {
      final key = '${SecureStorageKey.favoriteFood}_${params.eventId}';
      await sharedPreferencesStorage.save(
        key: key,
        value: params.data,
      );
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
