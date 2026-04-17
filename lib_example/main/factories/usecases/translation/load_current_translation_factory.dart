import '../../../../data/usecases/translation/local_load_current_translation.dart';
import '../../../../domain/usecases/translation/load_current_translation.dart';
import '../../cache/shared_preferences_storage_adapter_factory.dart';

LoadCurrentTranslation makeLoadCurrentTranslation() =>
    LocalLoadCurrentTranslation(
        sharedPreferencesStorage: makeSharedPreferencesStorageAdapter());
