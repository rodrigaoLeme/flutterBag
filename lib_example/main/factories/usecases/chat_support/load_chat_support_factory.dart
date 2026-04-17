import '../../../../data/usecases/usecases.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../http/http.dart';

LoadChatSupport makeRemoteLoadChatSupport() => RemoteLoadChatSupport(
      httpClient: makeAuthorizeHttpClientDecorator(),
      url: makeApiUrl('chat/support'),
    );
