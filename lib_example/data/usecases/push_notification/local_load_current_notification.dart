import 'dart:convert';

import '../../../domain/entities/notification/notification_entity.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/push_notification/load_current_notification.dart';
import '../../cache/cache.dart';
import '../../models/notification/remote_notification_model.dart';

class LocalLoadCurrentNotification implements LoadCurrentNotification {
  final SharedPreferencesStorage sharedPreferencesStorage;

  LocalLoadCurrentNotification({
    required this.sharedPreferencesStorage,
  });

  @override
  Future<NotificationEntity?> load({
    required LoadCurrentNotificationParams params,
  }) async {
    try {
      final key = '${SecureStorageKey.notification}_${params.eventId}';
      final data = await sharedPreferencesStorage.fetch(key);
      if (data == null) throw DomainError.expiredSession;
      final model =
          RemoteNotificationModel.fromJson(jsonDecode(data)).toEntity();
      return model;
    } catch (error) {
      return null;
    }
  }
}
