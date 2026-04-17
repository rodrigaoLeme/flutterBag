import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/push_notification/save_current_notification.dart';
import '../../cache/cache.dart';

class LocalSaveCurrentNotification implements SaveCurrentNotification {
  final SharedPreferencesStorage sharedPreferencesStorage;

  LocalSaveCurrentNotification({
    required this.sharedPreferencesStorage,
  });

  @override
  Future<void> save({required SaveCurrentNotificationParams params}) async {
    try {
      final key = '${SecureStorageKey.notification}_${params.eventId}';
      await sharedPreferencesStorage.save(
        key: key,
        value: params.data,
      );
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
