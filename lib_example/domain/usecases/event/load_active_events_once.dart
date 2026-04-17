import 'package:cloud_firestore/cloud_firestore.dart';

abstract class LoadActiveEventOnce {
  Future<DocumentSnapshot<Map<String, dynamic>>?> load();
}
