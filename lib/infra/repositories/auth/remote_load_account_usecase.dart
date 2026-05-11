import '../../../data/http/http_client.dart';
import '../../../domain/entities/account_entity.dart';
import '../../../domain/usecases/auth/auth_usecases.dart';
import '../../../main/flavors.dart';
import '../../../main/i18n/app_i18n.dart';

class RemoteLoadAccountUsecase implements LoadAccountUsecase {
  final HttpClient httpClient;

  const RemoteLoadAccountUsecase({required this.httpClient});

  @override
  Future<AccountEntity> load() async {
    try {
      final response = await httpClient.request(
        url: '${Flavor.apiBaseUrl}/account/me',
        method: HttpMethod.get,
      );
      return AccountEntity.fromJson(
        Map<String, dynamic>.from(response as Map),
      );
    } on HttpError catch (e) {
      if (e == HttpError.unauthorized || e == HttpError.forbidden) {
        throw const EmailNotConfirmedException();
      }
      throw Exception(AppI18n.current.errorUnexpected);
    }
  }
}
