import '../../../../data/usecases/profile/profile.dart';
import '../../../../domain/usecases/usecases.dart';
import '../../http/http.dart';

LoadProfile makeRemoteLoadProfile() => RemoteLoadProfile(
      httpClient: makeAuthorizeHttpClientDecorator(),
      url: makeApiUrl('profile/'),
    );
