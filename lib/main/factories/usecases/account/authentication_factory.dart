import '../../../../data/usecases/account/remote_authentication.dart';
import '../../../../domain/usecases/account/authentication.dart';
import '../../http/http.dart';

Authentication makeRemoteAuthentication() => RemoteAuthentication(
      httpClient: makeDioAdapter(),
      url: makeApiUrl('auth/login'),
    );
