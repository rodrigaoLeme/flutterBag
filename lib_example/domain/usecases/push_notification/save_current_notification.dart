abstract class SaveCurrentNotification {
  Future<void> save({required SaveCurrentNotificationParams params});
}

class SaveCurrentNotificationParams {
  final String eventId;
  final String data;
  SaveCurrentNotificationParams({
    required this.eventId,
    required this.data,
  });
}
