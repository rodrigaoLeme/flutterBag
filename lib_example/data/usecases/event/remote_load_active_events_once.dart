import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/usecases/event/load_active_events_once.dart';
import '../../firebase/firestore_client.dart';

class RemoteLoadActiveEventsOnce implements LoadActiveEventOnce {
  final String collectionPath;
  final FirestoreClient client;

  RemoteLoadActiveEventsOnce({
    required this.client,
    required this.collectionPath,
  });

  @override
  Future<DocumentSnapshot<Map<String, dynamic>>?> load() {
    return client.getById(collectionPath, 'data');
  }
}
