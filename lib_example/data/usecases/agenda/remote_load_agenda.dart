import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/usecases/usecases.dart';
import '../../firebase/firestore_client.dart';

class RemoteLoadAgenda implements LoadAgenda {
  final FirestoreClient clientId;
  final String collectionPath;

  RemoteLoadAgenda({
    required this.clientId,
    required this.collectionPath,
  });

  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>>? load(
      {required LoadScheduleParams params}) {
    return clientId.getStream(collectionPath, params.eventSchedule);
  }
}
