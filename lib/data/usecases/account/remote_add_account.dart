import '../../../domain/entities/account/account_entity.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/account/add_account.dart';
import '../../http/http.dart';
import '../../models/account/remote_account_model.dart';

class RemoteAddAccount implements AddAccount {
  final HttpClient httpClient;
  final String url;

  RemoteAddAccount({required this.httpClient, required this.url});

  @override
  Future<AccountEntity> add(AddAccountParams params) async {
    try {
      final body = {
        'name': params.name,
        'email': params.email,
        'cpf': params.cpf,
        'phone': params.phone,
        'password': params.password,
        'passwordConfirmation': params.passwordConfirmation,
      };
      final response = await httpClient.request(
        url: url,
        method: HttpMethod.post,
        body: body,
      );
      return RemoteAccountModel.fromJson(response).toEntity();
    } on HttpError catch (error) {
      switch (error) {
        case HttpError.forbidden:
          throw DomainError.emailInUse;
        default:
          throw DomainError.unexpected;
      }
    }
  }
}
