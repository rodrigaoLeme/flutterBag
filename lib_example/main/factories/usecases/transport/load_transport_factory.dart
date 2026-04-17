import '../../../../data/usecases/transport/remote_load_transport.dart';
import '../../../../domain/usecases/transport/load_transport.dart';
import '../../firebase/firestore_client_factory.dart';

LoadTransport makeRemoteLoadTransport() => RemoteLoadTransport(
      client: makeFirestoreClient(),
      collectionPath: 'event-transport',
    );
