import '../../../../data/usecases/usecases.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../http/http.dart';

LoadStLouis makeRemoteLoadStLouis() => RemoteLoadStLouis(
      httpClient: makeAuthorizeHttpClientDecorator(),
      url: makeApiUrl('st/louis'),
    );
