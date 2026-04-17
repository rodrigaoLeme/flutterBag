import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/firebase/firestore_client.dart';

class FirestoreAdapter implements FirestoreClient {
  final FirebaseFirestore _firestore;

  FirestoreAdapter(this._firestore);

  @override
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getAll(
      String collectionPath) async {
    try {
      final querySnapshot = await _firestore.collection(collectionPath).get();
      return querySnapshot.docs;
    } catch (e) {
      throw Exception('Erro ao buscar documentos: $e');
    }
  }

  @override
  Future<DocumentSnapshot<Map<String, dynamic>>?> getById(
      String collectionPath, String id) async {
    try {
      final document =
          await _firestore.collection(collectionPath).doc(id).get();
      return document;
    } catch (e) {
      throw Exception('Erro ao buscar documento: $e');
    }
  }

  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>>? getStream(
      String collectionPath, String id) {
    try {
      return _firestore.collection(collectionPath).doc(id).snapshots();
    } catch (e) {
      return null;
    }
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>>? getStreamByDocs(
    String collectionPath,
    String id,
    String collectionPathTwo,
  ) {
    try {
      return _firestore
          .collection(collectionPath)
          .doc(id)
          .collection(collectionPathTwo)
          .snapshots();
    } catch (e) {
      return null;
    }
  }
}
