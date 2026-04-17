import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/usecases/documents/load_documents.dart';
import '../../firebase/firestore_client.dart';

class RemoteLoadDocuments implements LoadDocuments {
  final String collectionPath;
  final FirestoreClient client;

  RemoteLoadDocuments({
    required this.client,
    required this.collectionPath,
  });

  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>>? load(
      {required LoadDocumentsParams params}) {
    return client.getStream(collectionPath, params.eventId);
  }
}
