import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../data/firebase/firestore_client.dart';
import '../../../infra/firebase/firestore_adapter.dart';

FirestoreClient makeFirestoreClient() {
  return FirestoreAdapter(FirebaseFirestore.instance);
}
