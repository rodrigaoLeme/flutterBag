import '../../../../data/usecases/agenda/local_load_current_agenda.dart';
import '../../../../domain/usecases/agenda/load_current_agenda.dart';
import '../../cache/shared_preferences_storage_adapter_factory.dart';

LoadCurrentAgenda makeLocalLoadCurrentAgenda() => LocalLoadCurrentAgenda(
    sharedPreferencesStorage: makeSharedPreferencesStorageAdapter());
