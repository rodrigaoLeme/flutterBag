import '../../../../data/usecases/event/remote_load_active_events_once.dart';
import '../../../../domain/usecases/event/load_active_events_once.dart';
import '../../firebase/firestore_client_factory.dart';

LoadActiveEventOnce makeRemoteLoadActiveEventOnce() =>
    RemoteLoadActiveEventsOnce(
      client: makeFirestoreClient(),
      collectionPath: 'active-events',
    );
