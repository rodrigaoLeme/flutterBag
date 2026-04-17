import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/usecases/brochures/load_brochures.dart';
import '../../firebase/firestore_client.dart';

class RemoteLoadBrochures implements LoadBrochures {
  final String collectionPath;
  final FirestoreClient client;

  RemoteLoadBrochures({
    required this.client,
    required this.collectionPath,
  });

  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>>? load(
      {required LoadBrochuresParams params}) {
    return client.getStream(collectionPath, params.eventId);
  }
}
