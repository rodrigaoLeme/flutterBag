import '../../../../data/usecases/push_notification/local_load_current_screen_type.dart';
import '../../../../domain/usecases/push_notification/load_current_screen_type.dart';
import '../../cache/shared_preferences_storage_adapter_factory.dart';

LoadCurrentScreenType makeLocalLoadCurrentScreenType() =>
    LocalLoadCurrentScreenType(
      sharedPreferencesStorage: makeSharedPreferencesStorageAdapter(),
    );
