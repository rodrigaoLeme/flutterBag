import '../../../../data/usecases/push_notification/local_load_current_notification.dart';
import '../../../../domain/usecases/push_notification/load_current_notification.dart';
import '../../cache/shared_preferences_storage_adapter_factory.dart';

LoadCurrentNotification makeLoadCurrentNotification() =>
    LocalLoadCurrentNotification(
      sharedPreferencesStorage: makeSharedPreferencesStorageAdapter(),
    );
