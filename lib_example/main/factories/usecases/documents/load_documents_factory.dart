import '../../../../data/usecases/documents/remote_load_documents.dart';
import '../../../../domain/usecases/documents/load_documents.dart';
import '../../firebase/firestore_client_factory.dart';

LoadDocuments makeRemoteLoadDocuments() => RemoteLoadDocuments(
      client: makeFirestoreClient(),
      collectionPath: 'event-documents',
    );
