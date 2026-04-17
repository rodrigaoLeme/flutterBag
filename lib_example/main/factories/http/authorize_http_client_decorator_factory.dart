import '../../../data/http/http.dart';
import '../../decorators/decorators.dart';
import '../cache/shared_preferences_storage_adapter_factory.dart';
import '../usecases/account/load_current_account_factory.dart';
import 'dio_client_factory.dart';

HttpClient makeAuthorizeHttpClientDecorator() => AuthorizeHttpClientDecorator(
      decoratee: makeDioAdapter(),
      loadCurrentAccount: makeLocalLoadCurrentAccount(),
      sharedPreferencesStorage: makeSharedPreferencesStorageAdapter(),
    );
