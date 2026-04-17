import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/usecases/push_notification/load_notification_once.dart';
import '../../firebase/firestore_client.dart';

class RemoteLoadNotificationOnce implements LoadNotificationOnce {
  final String collectionPath;
  final FirestoreClient client;

  RemoteLoadNotificationOnce({
    required this.collectionPath,
    required this.client,
  });

  @override
  Future<DocumentSnapshot<Map<String, dynamic>>?> load({
    required LoadNotificationOnceParams params,
  }) {
    return client.getById(
      collectionPath,
      params.eventId,
    );
  }
}
