import 'package:cloud_firestore/cloud_firestore.dart';

abstract class LoadNotificationOnce {
  Future<DocumentSnapshot<Map<String, dynamic>>?> load({
    required LoadNotificationOnceParams params,
  });
}

class LoadNotificationOnceParams {
  final String eventId;
  LoadNotificationOnceParams({
    required this.eventId,
  });
}
