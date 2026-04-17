import '../../../../data/usecases/exhibition/local_save_current_exhibitions.dart';
import '../../../../domain/usecases/exhibition/save_current_exhibition.dart';
import '../../cache/shared_preferences_storage_adapter_factory.dart';

SaveCurrentExhibition makeSaveCurrentExhibitions() =>
    LocalSaveCurrentExhibitions(
      sharedPreferencesStorage: makeSharedPreferencesStorageAdapter(),
    );
