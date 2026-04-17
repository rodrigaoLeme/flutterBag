import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/usecases/menu/load_menu.dart';
import '../../firebase/firestore_client.dart';

class RemoteLoadMenu implements LoadMenu {
  final String collectionPath;
  final FirestoreClient client;

  RemoteLoadMenu({
    required this.client,
    required this.collectionPath,
  });

  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>>? load() {
    return client.getStream(collectionPath, 'data');
  }
}
