import '../../../../data/usecases/translation_channel/remote_load_translation_channel.dart';
import '../../../../domain/usecases/translation_channel/load_translation_channel.dart';
import '../../firebase/firestore_client_factory.dart';

LoadTranslationChannel makeRemoteLoadTranslationChannel() =>
    RemoteLoadTranslationChannel(
      client: makeFirestoreClient(),
      collectionPath: 'event-translation-channels',
    );
