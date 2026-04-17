import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/usecases/usecases.dart';
import '../../firebase/firestore_client.dart';

class RemoteLoadVoting implements LoadVoting {
  final String collectionPath;
  final FirestoreClient client;

  RemoteLoadVoting({
    required this.client,
    required this.collectionPath,
  });

  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>>? load(
      {required LoadVotingParams params}) {
    return client.getStream(collectionPath, params.eventId);
  }
}
