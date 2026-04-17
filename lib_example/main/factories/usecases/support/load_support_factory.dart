import '../../../../data/usecases/usecases.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../firebase/firestore_client_factory.dart';

LoadSupport makeRemoteLoadSupport() => RemoteLoadSupport(
      client: makeFirestoreClient(),
      collectionPath: 'event-faq',
    );
