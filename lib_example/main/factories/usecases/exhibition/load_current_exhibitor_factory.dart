import '../../../../data/usecases/exhibition/local_load_current_exhibitor.dart';
import '../../../../domain/usecases/exhibition/load_current_exhibitor.dart';
import '../../cache/shared_preferences_storage_adapter_factory.dart';

LoadCurrentExhibitor makeLoadCurrentExhibitor() => LocalLoadCurrentExhibitor(
      sharedPreferencesStorage: makeSharedPreferencesStorageAdapter(),
    );
