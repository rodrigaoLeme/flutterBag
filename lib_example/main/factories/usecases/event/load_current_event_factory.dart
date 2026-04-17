import '../../../../data/usecases/event/local_load_current_event.dart';
import '../../../../domain/usecases/event/load_current_event.dart';
import '../../cache/shared_preferences_storage_adapter_factory.dart';

LoadCurrentEvent makeLocalLoadCurrentEvent() => LocalLoadCurrentEvent(
    sharedPreferencesStorage: makeSharedPreferencesStorageAdapter());
