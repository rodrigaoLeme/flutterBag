import '../../../../data/usecases/get_in_line/remote_load_get_in_line.dart';
import '../../../../domain/usecases/get_in_line/load_get_in_line.dart';
import '../../http/http.dart';

LoadGetInLine makeRemoteLoadGetInLine() => RemoteLoadGetInLine(
      httpClient: makeAuthorizeHttpClientDecorator(),
      url: makeApiUrl('get/in/line'),
    );
