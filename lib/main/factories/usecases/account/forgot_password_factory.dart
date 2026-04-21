import '../../../../data/usecases/account/remote_forgot_password.dart';
import '../../../../domain/usecases/account/forgot_password.dart';
import '../../http/http.dart';

ForgotPassword makeRemoteForgotPassword() => RemoteForgotPassword(
      httpClient: makeDioAdapter(),
      url: makeApiUrl('auth/forgot-password'),
    );
