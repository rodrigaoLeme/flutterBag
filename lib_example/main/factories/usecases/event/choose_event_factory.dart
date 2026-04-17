import '../../../../data/usecases/event/remote_load_active_events.dart';
import '../../../../domain/usecases/event/load_active_events.dart';
import '../../firebase/firestore_client_factory.dart';

LoadActiveEvent makeRemoteLoadActiveEvent() => RemoteLoadActiveEvent(
      client: makeFirestoreClient(),
      collectionPath: 'active-events',
    );
