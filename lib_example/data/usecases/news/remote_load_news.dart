import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/usecases/usecases.dart';
import '../../firebase/firestore_client.dart';

class RemoteLoadNews implements LoadNews {
  final String collectionPath;
  final FirestoreClient client;

  RemoteLoadNews({
    required this.collectionPath,
    required this.client,
  });

  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>>? load(
      {required LoadNewsParams params}) {
    return client.getStream(
      collectionPath,
      params.eventId,
    );
  }
}
