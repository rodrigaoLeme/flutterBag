import '../../../../data/usecases/push_notification/local_save_current_screen_type.dart';
import '../../../../domain/usecases/push_notification/save_current_screen_type.dart';
import '../../cache/shared_preferences_storage_adapter_factory.dart';

SaveCurrentScreenType makeLocalSaveCurrentScreenType() =>
    LocalSaveCurrentScreenType(
      sharedPreferencesStorage: makeSharedPreferencesStorageAdapter(),
    );
