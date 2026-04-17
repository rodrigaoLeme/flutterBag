import '../../entities/notification/notification_entity.dart';

abstract class LoadCurrentNotification {
  Future<NotificationEntity?> load({
    required LoadCurrentNotificationParams params,
  });
}

class LoadCurrentNotificationParams {
  final String eventId;

  LoadCurrentNotificationParams({
    required this.eventId,
  });
}
