import '../../../domain/entities/account/account_entity.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/account/authentication.dart';
import '../../http/http.dart';
import '../../models/account/remote_account_model.dart';

class RemoteAuthentication implements Authentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({required this.httpClient, required this.url});

  @override
  Future<AccountEntity> auth(AuthenticationParams params) async {
    try {
      final body = {
        'identifier': params.identifier,
        'password': params.password,
      };
      final response = await httpClient.request(
        url: url,
        method: HttpMethod.post,
        body: body,
      );
      return RemoteAccountModel.fromJson(response).toEntity();
    } on HttpError catch (error) {
      switch (error) {
        case HttpError.unauthorized:
        case HttpError.notFound:
          throw DomainError.invalidCredentials;
        default:
          throw DomainError.unexpected;
      }
    }
  }
}
