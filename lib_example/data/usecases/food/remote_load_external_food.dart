import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/usecases/food/load_external_food.dart';
import '../../firebase/firestore_client.dart';

class RemoteLoadExternalFood implements LoadExternalFood {
  final String collectionPath;
  final FirestoreClient client;

  RemoteLoadExternalFood({
    required this.client,
    required this.collectionPath,
  });

  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>>? load({
    required LoadExternalFoodParams params,
  }) {
    return client.getStream(collectionPath, params.eventId);
  }
}
