import '../../../../data/usecases/social_media/remote_load_social_media.dart';
import '../../../../domain/usecases/social_media/load_social_media.dart';
import '../../firebase/firestore_client_factory.dart';

LoadSocialMedia makeRemoteLoadSocialMedia() => RemoteLoadSocialMedia(
      client: makeFirestoreClient(),
      collectionPath: 'event-social-profile',
    );
