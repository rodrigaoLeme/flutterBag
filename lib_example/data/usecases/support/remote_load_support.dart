import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/usecases/usecases.dart';
import '../../firebase/firestore_client.dart';

class RemoteLoadSupport implements LoadSupport {
  final String collectionPath;
  final FirestoreClient client;

  RemoteLoadSupport({
    required this.client,
    required this.collectionPath,
  });

  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>>? load(
      {required LoadSupportParams params}) {
    return client.getStream(collectionPath, params.eventId);
  }
}
