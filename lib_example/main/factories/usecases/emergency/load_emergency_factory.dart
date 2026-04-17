import '../../../../data/usecases/emergency/remote_load_emergency.dart';
import '../../../../domain/usecases/emergency/load_emergency.dart';
import '../../firebase/firestore_client_factory.dart';

LoadEmergency makeRemoteLoadEmergency() => RemoteLoadEmergency(
      client: makeFirestoreClient(),
      collectionPath: 'emergency',
    );
