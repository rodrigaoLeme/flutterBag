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
      final body = RemoteAuthenticationParams.fromDomain(params).toJson();
      final httpResponse = await httpClient.request(
          url: url, method: HttpMethod.post, body: body);
      return RemoteAccountModel.fromJson(httpResponse).toEntity();
    } on HttpError catch (error) {
      switch (error) {
        case HttpError.unauthorized:
          throw DomainError.invalidCredentials;
        case HttpError.notFound:
          throw DomainError.invalidCredentials;
        default:
          throw DomainError.unexpected;
      }
    }
  }
}

class RemoteAuthenticationParams {
  final String email;
  final String password;

  RemoteAuthenticationParams({
    required this.email,
    required this.password,
  });

  factory RemoteAuthenticationParams.fromDomain(AuthenticationParams params) =>
      RemoteAuthenticationParams(
        email: params.email,
        password: params.password,
      );

  Map toJson() => {
        'email': email,
        'password': password,
      };
}
