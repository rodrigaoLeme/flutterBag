import '../../../../data/usecases/usecases.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../firebase/firestore_client_factory.dart';

LoadEventDetails makeRemoteLoadEventDetails() => RemoteLoadEventDetails(
      client: makeFirestoreClient(),
      collectionPath: 'event-details',
    );
