import '../../../../data/usecases/agenda/local_save_current_agenda.dart';
import '../../../../domain/usecases/agenda/save_current_agenda.dart';
import '../../cache/shared_preferences_storage_adapter_factory.dart';

SaveCurrentAgenda makeSaveCurrentAgenda() => LocalSaveCurrentAgenda(
    sharedPreferencesStorage: makeSharedPreferencesStorageAdapter());
