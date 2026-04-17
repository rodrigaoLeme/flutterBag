import '../../../../data/usecases/translation/local_save_current_translation.dart';
import '../../../../domain/usecases/translation/save_current_translation.dart';
import '../../cache/shared_preferences_storage_adapter_factory.dart';

SaveCurrentTranslation makeSaveCurrentTranslation() =>
    LocalSaveCurrentTranslation(
        sharedPreferencesStorage: makeSharedPreferencesStorageAdapter());
