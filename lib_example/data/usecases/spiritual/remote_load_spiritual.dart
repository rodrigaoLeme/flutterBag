import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/usecases/spiritual/load_spiritual.dart';
import '../../firebase/firestore_client.dart';

class RemoteLoadSpiritual implements LoadSpiritual {
  final String collectionPath;
  final FirestoreClient client;

  RemoteLoadSpiritual({
    required this.client,
    required this.collectionPath,
  });

  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>>? load(
      {required LoadSpiritualParams params}) {
    return client.getStream(collectionPath, params.eventId);
  }
}
