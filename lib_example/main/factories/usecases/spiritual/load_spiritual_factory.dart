import '../../../../data/usecases/spiritual/remote_load_spiritual.dart';
import '../../../../domain/usecases/spiritual/load_spiritual.dart';
import '../../firebase/firestore_client_factory.dart';

LoadSpiritual makeRemoteLoadSpiritual() => RemoteLoadSpiritual(
      client: makeFirestoreClient(),
      collectionPath: 'event-spiritual',
    );
