import 'package:cloud_firestore/cloud_firestore.dart';

abstract class LoadBrochures {
  Stream<DocumentSnapshot<Map<String, dynamic>>>? load(
      {required LoadBrochuresParams params});
}

class LoadBrochuresParams {
  final String eventId;
  LoadBrochuresParams({
    required this.eventId,
  });
}
