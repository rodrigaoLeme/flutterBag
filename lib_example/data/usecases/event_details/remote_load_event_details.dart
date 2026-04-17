import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/usecases/usecases.dart';
import '../../firebase/firestore_client.dart';

class RemoteLoadEventDetails implements LoadEventDetails {
  final String collectionPath;
  final FirestoreClient client;

  RemoteLoadEventDetails({
    required this.client,
    required this.collectionPath,
  });

  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>>? load(
      {required LoadEventDetailsParams params}) {
    return client.getStream(collectionPath, params.eventId);
  }
}
