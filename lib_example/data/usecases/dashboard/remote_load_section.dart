import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/usecases/dashboard/load_section.dart';
import '../../firebase/firestore_client.dart';

class RemoteLoadSection implements LoadSection {
  final String collectionPath;
  final FirestoreClient client;

  RemoteLoadSection({
    required this.client,
    required this.collectionPath,
  });

  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>>? load(
      {required LoadSectionParams params}) {
    return client.getStream(collectionPath, params.eventId);
  }
}
