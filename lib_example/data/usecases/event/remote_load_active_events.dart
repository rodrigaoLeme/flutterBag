import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/usecases/event/load_active_events.dart';
import '../../firebase/firestore_client.dart';

class RemoteLoadActiveEvent implements LoadActiveEvent {
  final String collectionPath;
  final FirestoreClient client;

  RemoteLoadActiveEvent({
    required this.client,
    required this.collectionPath,
  });

  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>>? load() {
    return client.getStream(collectionPath, 'data');
  }
}
