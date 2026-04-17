import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/usecases/translation_channel/load_translation_channel.dart';
import '../../firebase/firestore_client.dart';

class RemoteLoadTranslationChannel implements LoadTranslationChannel {
  final String collectionPath;
  final FirestoreClient client;

  RemoteLoadTranslationChannel({
    required this.client,
    required this.collectionPath,
  });

  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>>? load(
      {required LoadTranslationChannelParams params}) {
    return client.getStream(collectionPath, params.eventId);
  }
}
