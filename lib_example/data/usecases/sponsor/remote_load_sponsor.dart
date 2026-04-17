import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/usecases/sponsor/load_sponsor.dart';
import '../../firebase/firestore_client.dart';

class RemoteLoadSponsor implements LoadSponsor {
  final String collectionPath;
  final FirestoreClient client;

  RemoteLoadSponsor({
    required this.client,
    required this.collectionPath,
  });

  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>>? load(
      {required LoadSponsorParams params}) {
    return client.getStream(collectionPath, params.eventId);
  }
}
