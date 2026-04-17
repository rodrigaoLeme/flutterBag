import '../../../../data/usecases/food/local_load_current_external_food.dart';
import '../../../../domain/usecases/food/load_current_external_food.dart';
import '../../cache/shared_preferences_storage_adapter_factory.dart';

LoadCurrentExternalFood makeLoadCurrentExternalFood() =>
    LocalLoadCurrentExternalFood(
      sharedPreferencesStorage: makeSharedPreferencesStorageAdapter(),
    );
