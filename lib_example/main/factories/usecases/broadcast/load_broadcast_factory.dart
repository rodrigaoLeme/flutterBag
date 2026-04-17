import '../../../../data/usecases/broadcast/remote_load_broadcast.dart';
import '../../../../domain/usecases/broadcast/load_broadcast.dart';
import '../../firebase/firestore_client_factory.dart';

LoadBroadcast makeRemoteLoadBroadcast() => RemoteLoadBroadcast(
      client: makeFirestoreClient(),
      collectionPath: 'event-broadcast',
    );
