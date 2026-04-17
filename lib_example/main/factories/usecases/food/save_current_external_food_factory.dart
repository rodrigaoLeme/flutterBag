import '../../../../data/usecases/food/local_save_current_external_food.dart';
import '../../../../domain/usecases/food/save_current_external_food.dart';
import '../../cache/shared_preferences_storage_adapter_factory.dart';

SaveCurrentExternalFood makeSaveCurrentExternalFood() =>
    LocalSaveCurrentExternalFood(
      sharedPreferencesStorage: makeSharedPreferencesStorageAdapter(),
    );
