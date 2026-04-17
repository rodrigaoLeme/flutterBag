import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/usecases/transport/load_transport.dart';
import '../../firebase/firestore_client.dart';

class RemoteLoadTransport implements LoadTransport {
  final String collectionPath;
  final FirestoreClient client;

  RemoteLoadTransport({
    required this.client,
    required this.collectionPath,
  });

  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>>? load(
      {required LoadTransportParams params}) {
    return client.getStream(collectionPath, params.eventId);
  }
}
