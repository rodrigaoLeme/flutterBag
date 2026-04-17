import '../../../../data/usecases/sponsor/remote_load_sponsor.dart';
import '../../../../domain/usecases/sponsor/load_sponsor.dart';
import '../../firebase/firestore_client_factory.dart';

LoadSponsor makeRemoteLoadSponsor() => RemoteLoadSponsor(
      client: makeFirestoreClient(),
      collectionPath: 'event-sponsor',
    );
