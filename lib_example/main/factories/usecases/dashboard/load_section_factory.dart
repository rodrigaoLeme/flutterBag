import '../../../../data/usecases/dashboard/remote_load_section.dart';
import '../../../../domain/usecases/dashboard/load_section.dart';
import '../../firebase/firestore_client_factory.dart';

LoadSection makeRemoteLoadSection() => RemoteLoadSection(
      client: makeFirestoreClient(),
      collectionPath: 'event-sections',
    );
