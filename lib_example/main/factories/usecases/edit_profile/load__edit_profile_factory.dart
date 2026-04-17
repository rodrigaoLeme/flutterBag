import '../../../../data/usecases/usecases.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../http/http.dart';

LoadEditProfile makeRemoteLoadEditProfile() => RemoteLoadEditProfile(
      httpClient: makeAuthorizeHttpClientDecorator(),
      url: makeApiUrl('profile/'),
    );
