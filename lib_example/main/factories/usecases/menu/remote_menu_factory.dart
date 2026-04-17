import '../../../../data/usecases/menu/remote_load_menu.dart';
import '../../../../domain/usecases/menu/load_menu.dart';
import '../../firebase/firestore_client_factory.dart';

LoadMenu makeRemoteLoadMenu() => RemoteLoadMenu(
      client: makeFirestoreClient(),
      collectionPath: 'menu',
    );
