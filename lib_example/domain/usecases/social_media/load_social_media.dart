import 'package:cloud_firestore/cloud_firestore.dart';

abstract class LoadSocialMedia {
  Stream<DocumentSnapshot<Map<String, dynamic>>>? load(
      {required LoadSocialMediaParams params});
}

class LoadSocialMediaParams {
  final String eventId;
  LoadSocialMediaParams({
    required this.eventId,
  });
}
