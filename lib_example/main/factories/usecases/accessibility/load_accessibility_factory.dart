import '../../../../data/usecases/accessibility/remote_load_accessibility.dart';
import '../../../../domain/usecases/accessibility/load_accessibility.dart';
import '../../firebase/firestore_client_factory.dart';

LoadAccessibility makeRemoteLoadAccessibility() => RemoteLoadAccessibility(
      client: makeFirestoreClient(),
      collectionPath: 'event-accessibility',
    );
