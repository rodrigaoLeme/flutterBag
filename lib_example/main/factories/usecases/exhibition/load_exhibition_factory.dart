import '../../../../data/usecases/exhibition/remote_load_exhibition.dart';
import '../../../../domain/usecases/exhibition/load_exhibition.dart';
import '../../firebase/firestore_client_factory.dart';

LoadExhibition makeRemoteLoadExhibition() => RemoteLoadExhibition(
      client: makeFirestoreClient(),
      collectionPath: 'event-exhibitor',
    );
