import 'package:cloud_firestore/cloud_firestore.dart';

abstract class LoadExhibition {
  Stream<DocumentSnapshot<Map<String, dynamic>>>? load(
      {required LoadExhibitionParams params});
}

class LoadExhibitionParams {
  final String eventId;
  LoadExhibitionParams({
    required this.eventId,
  });
}
