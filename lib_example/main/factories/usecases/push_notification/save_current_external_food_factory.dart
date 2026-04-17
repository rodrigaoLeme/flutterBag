import '../../../../data/usecases/push_notification/local_save_current_notification.dart';
import '../../../../domain/usecases/push_notification/save_current_notification.dart';
import '../../cache/shared_preferences_storage_adapter_factory.dart';

SaveCurrentNotification makeSaveCurrentNotification() =>
    LocalSaveCurrentNotification(
      sharedPreferencesStorage: makeSharedPreferencesStorageAdapter(),
    );
