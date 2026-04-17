import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/usecases/map/load_map.dart';
import '../../firebase/firestore_client.dart';

class RemoteLoadMap implements LoadMap {
  final String collectionPath;
  final FirestoreClient client;

  RemoteLoadMap({
    required this.client,
    required this.collectionPath,
  });

  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>>? load(
      {required LoadMapParams params}) {
    return client.getStream(collectionPath, params.eventId);
  }
}
