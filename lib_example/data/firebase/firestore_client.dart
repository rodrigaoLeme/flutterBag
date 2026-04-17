import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FirestoreClient<T> {
  Future<List<T>> getAll(String collectionPath);

  Future<DocumentSnapshot<Map<String, dynamic>>?> getById(
      String collectionPath, String id);

  Stream<DocumentSnapshot<Map<String, dynamic>>>? getStream(
      String collectionPath, String id);

  Stream<QuerySnapshot<Map<String, dynamic>>>? getStreamByDocs(
      String collectionPath, String id, String collectionPathTwo);
}
