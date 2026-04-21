import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/account/forgot_password.dart';
import '../../http/http.dart';

class RemoteForgotPassword implements ForgotPassword {
  final HttpClient httpClient;
  final String url;

  RemoteForgotPassword({required this.httpClient, required this.url});

  @override
  Future<void> send({required String identifier}) async {
    try {
      await httpClient.request(
        url: url,
        method: HttpMethod.post,
        body: {'identifier': identifier},
      );
    } on HttpError {
      throw DomainError.unexpected;
    }
  }
}
