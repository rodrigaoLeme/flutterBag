import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/usecases/emergency/load_emergency.dart';
import '../../firebase/firestore_client.dart';

class RemoteLoadEmergency implements LoadEmergency {
  final String collectionPath;
  final FirestoreClient client;

  RemoteLoadEmergency({
    required this.collectionPath,
    required this.client,
  });

  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>>? load(
      {required LoadEmergencyParams params}) {
    return client.getStream(collectionPath, params.eventId);
  }
}
