import 'package:cloud_firestore/cloud_firestore.dart';

abstract class LoadSection {
  Stream<DocumentSnapshot<Map<String, dynamic>>>? load(
      {required LoadSectionParams params});
}

class LoadSectionParams {
  final String eventId;
  LoadSectionParams({
    required this.eventId,
  });
}
