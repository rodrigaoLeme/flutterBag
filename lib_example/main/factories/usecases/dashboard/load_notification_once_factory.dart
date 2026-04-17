import '../../../../data/usecases/push_notification/remote_load_notification_once.dart';
import '../../../../domain/usecases/push_notification/load_notification_once.dart';
import '../../firebase/firestore_client_factory.dart';

LoadNotificationOnce makeRemoteLoadNotificationOnce() =>
    RemoteLoadNotificationOnce(
      client: makeFirestoreClient(),
      collectionPath: 'push-notifications',
    );
