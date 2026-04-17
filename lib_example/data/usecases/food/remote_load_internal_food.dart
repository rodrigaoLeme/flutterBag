import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/usecases/food/load_internal_food.dart';
import '../../firebase/firestore_client.dart';

class RemoteLoadInternalFood implements LoadInternalFood {
  final String collectionPath;
  final FirestoreClient client;

  RemoteLoadInternalFood({
    required this.client,
    required this.collectionPath,
  });

  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>>? load({
    required LoadInternalFoodParams params,
  }) {
    return client.getStream(collectionPath, params.eventId);
  }
}
