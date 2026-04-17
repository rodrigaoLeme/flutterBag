import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/usecases/push_notification/load_notification.dart';
import '../../firebase/firestore_client.dart';

class RemoteLoadNotification implements LoadNotification {
  final String collectionPath;
  final FirestoreClient client;

  RemoteLoadNotification({
    required this.collectionPath,
    required this.client,
  });

  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>>? load({
    required LoadNotificationParams params,
  }) {
    return client.getStream(
      collectionPath,
      params.eventId,
    );
  }
}
