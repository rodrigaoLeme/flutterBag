import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/usecases/exhibition/load_exhibition.dart';
import '../../firebase/firestore_client.dart';

class RemoteLoadExhibition implements LoadExhibition {
  final String collectionPath;
  final FirestoreClient client;

  RemoteLoadExhibition({
    required this.client,
    required this.collectionPath,
  });

  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>>? load(
      {required LoadExhibitionParams params}) {
    return client.getStream(collectionPath, params.eventId);
  }
}
