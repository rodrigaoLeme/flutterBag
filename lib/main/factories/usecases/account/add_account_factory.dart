import '../../../../data/usecases/account/remote_add_account.dart';
import '../../../../domain/usecases/account/add_account.dart';
import '../../http/http.dart';

AddAccount makeRemoteAddAccount() => RemoteAddAccount(
      httpClient: makeDioAdapter(),
      url: makeApiUrl('auth/register'),
    );
