import '../../../../data/usecases/food/remote_load_external_food.dart';
import '../../../../domain/usecases/food/load_external_food.dart';
import '../../firebase/firestore_client_factory.dart';

LoadExternalFood makeRemoteLoadExternalFood() => RemoteLoadExternalFood(
      client: makeFirestoreClient(),
      collectionPath: 'restaurants-external',
    );
