import '../../../../domain/usecases/account/update_contact_info.dart';
import '../../../../infra/repositories/account/remote_update_contact_info.dart';
import '../../http/http_factories.dart';

UpdateContactInfoUsecase makeRemoteUpdateContactInfo() =>
    RemoteUpdateContactInfoUsecase(
      httpClient: makeAuthorizeHttpClientDecorator(),
    );
