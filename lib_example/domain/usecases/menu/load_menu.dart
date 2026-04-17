import 'package:cloud_firestore/cloud_firestore.dart';

abstract class LoadMenu {
  Stream<DocumentSnapshot<Map<String, dynamic>>>? load();
}
