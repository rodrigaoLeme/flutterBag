import 'package:cloud_firestore/cloud_firestore.dart';

abstract class LoadNotification {
  Stream<DocumentSnapshot<Map<String, dynamic>>>? load({
    required LoadNotificationParams params,
  });
}

class LoadNotificationParams {
  final String eventId;
  LoadNotificationParams({
    required this.eventId,
  });
}
