import '../../../../data/usecases/food/remote_load_internal_food.dart';
import '../../../../domain/usecases/food/load_internal_food.dart';
import '../../firebase/firestore_client_factory.dart';

LoadInternalFood makeRemoteLoadFoodInternal() => RemoteLoadInternalFood(
      client: makeFirestoreClient(),
      collectionPath: 'restaurants-internal',
    );
