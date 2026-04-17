import '../../../../data/usecases/usecases.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../firebase/firestore_client_factory.dart';

LoadVoting makeRemoteLoadVoting() => RemoteLoadVoting(
      client: makeFirestoreClient(),
      collectionPath: 'voting-results',
    );
