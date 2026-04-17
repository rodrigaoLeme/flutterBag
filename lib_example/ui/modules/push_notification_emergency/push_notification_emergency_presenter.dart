import '../../../data/models/notification/remote_notification_model.dart';
import '../../../domain/entities/notification/notification_entity.dart';

abstract class PushNotificationEmergencyPresenter {
  Future<void> convinienceInit();
  Future<NotificationResultModel?> saveNotificationRead({
    required NotificationResultEntity? notificationRead,
  });
}
