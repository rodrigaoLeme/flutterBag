import '../../../../data/usecases/event/local_save_current_event.dart';
import '../../../../domain/usecases/event/save_current_event.dart';
import '../../cache/shared_preferences_storage_adapter_factory.dart';

SaveCurrentEvent makeSaveCurrentEvent() => LocalSaveCurrentEvent(
    sharedPreferencesStorage: makeSharedPreferencesStorageAdapter());
