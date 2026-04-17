import '../../../../data/usecases/map/remote_load_map.dart';
import '../../../../domain/usecases/map/load_map.dart';
import '../../firebase/firestore_client_factory.dart';

LoadMap makeRemoteLoadMap() => RemoteLoadMap(
      client: makeFirestoreClient(),
      collectionPath: 'event-map',
    );
