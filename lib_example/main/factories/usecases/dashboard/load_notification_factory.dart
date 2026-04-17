import '../../../../data/usecases/push_notification/remote_load_notification.dart';
import '../../../../domain/usecases/push_notification/load_notification.dart';
import '../../firebase/firestore_client_factory.dart';

LoadNotification makeRemoteLoadNotification() => RemoteLoadNotification(
      client: makeFirestoreClient(),
      collectionPath: 'push-notifications',
    );
