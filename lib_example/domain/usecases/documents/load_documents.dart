import 'package:cloud_firestore/cloud_firestore.dart';

abstract class LoadDocuments {
  Stream<DocumentSnapshot<Map<String, dynamic>>>? load(
      {required LoadDocumentsParams params});
}

class LoadDocumentsParams {
  final String eventId;
  LoadDocumentsParams({
    required this.eventId,
  });
}
