import 'package:cloud_firestore/cloud_firestore.dart';

abstract class LoadAccessibility {
  Stream<DocumentSnapshot<Map<String, dynamic>>>? load(
      {required LoadAccessibilityParams params});
}

class LoadAccessibilityParams {
  final String eventId;
  LoadAccessibilityParams({
    required this.eventId,
  });
}
