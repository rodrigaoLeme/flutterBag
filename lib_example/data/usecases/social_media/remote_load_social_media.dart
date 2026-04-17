import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/usecases/social_media/load_social_media.dart';
import '../../firebase/firestore_client.dart';

class RemoteLoadSocialMedia implements LoadSocialMedia {
  final String collectionPath;
  final FirestoreClient client;

  RemoteLoadSocialMedia({
    required this.client,
    required this.collectionPath,
  });

  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>>? load(
      {required LoadSocialMediaParams params}) {
    return client.getStream(collectionPath, params.eventId);
  }
}
