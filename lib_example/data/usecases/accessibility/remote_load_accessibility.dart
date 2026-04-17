import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/usecases/accessibility/load_accessibility.dart';
import '../../firebase/firestore_client.dart';

class RemoteLoadAccessibility implements LoadAccessibility {
  final String collectionPath;
  final FirestoreClient client;

  RemoteLoadAccessibility({
    required this.client,
    required this.collectionPath,
  });

  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>>? load(
      {required LoadAccessibilityParams params}) {
    return client.getStream(collectionPath, params.eventId);
  }
}
