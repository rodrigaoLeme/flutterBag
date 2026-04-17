import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/usecases/broadcast/load_broadcast.dart';
import '../../firebase/firestore_client.dart';

class RemoteLoadBroadcast implements LoadBroadcast {
  final String collectionPath;
  final FirestoreClient client;

  RemoteLoadBroadcast({
    required this.client,
    required this.collectionPath,
  });

  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>>? load(
      {required LoadBroadcastParams params}) {
    return client.getStream(collectionPath, params.eventId);
  }
}
