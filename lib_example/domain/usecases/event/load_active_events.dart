import 'package:cloud_firestore/cloud_firestore.dart';

abstract class LoadActiveEvent {
  Stream<DocumentSnapshot<Map<String, dynamic>>>? load();
}
