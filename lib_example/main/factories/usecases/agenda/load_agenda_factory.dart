import '../../../../data/usecases/agenda/remote_load_agenda.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../firebase/firestore_client_factory.dart';

LoadAgenda makeRemoteLoadAgenda() => RemoteLoadAgenda(
      clientId: makeFirestoreClient(),
      collectionPath: 'event-schedule',
    );
