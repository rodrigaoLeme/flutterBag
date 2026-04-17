import '../../../../data/usecases/business/remote_load_business.dart';
import '../../../../domain/usecases/business/load_business.dart';
import '../../http/http.dart';

LoadBusiness makeRemoteLoadBusiness() => RemoteLoadBusiness(
      httpClient: makeAuthorizeHttpClientDecorator(),
      url: makeApiUrl('business/'),
    );
