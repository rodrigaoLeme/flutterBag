import '../../../../data/usecases/brochures/remote_load_brochures.dart';
import '../../../../domain/usecases/brochures/load_brochures.dart';
import '../../firebase/firestore_client_factory.dart';

LoadBrochures makeRemoteLoadBrochures() => RemoteLoadBrochures(
      client: makeFirestoreClient(),
      collectionPath: 'event-brochure',
    );
