import '../../../data/http/http_client.dart';
import '../../../domain/usecases/account/update_contact_info.dart';
import '../../../main/flavors.dart';
import '../../../main/i18n/app_i18n.dart';

class RemoteUpdateContactInfoUsecase implements UpdateContactInfoUsecase {
  final HttpClient httpClient;

  const RemoteUpdateContactInfoUsecase({required this.httpClient});

  @override
  Future<void> update(UpdateContactInfoParams params) async {
    try {
      await httpClient.request(
        url: '${Flavor.apiBaseUrl}/account/me/contact-info',
        method: HttpMethod.put,
        body: {
          'email': params.email.trim().toLowerCase(),
          'mobileNumber': params.mobileNumber.replaceAll(RegExp(r'[^\d]'), ''),
        },
      );
    } on ApiException catch (e) {
      final message = e.title.isNotEmpty
          ? e.title
          : e.code.isNotEmpty
              ? e.code
              : AppI18n.current.errorUnexpected;
      throw UpdateContactInfoException(message);
    } on HttpError catch (e) {
      if (e == HttpError.unauthorized) {
        throw UpdateContactInfoException(AppI18n.current.loginAccessDenied);
      }
      if (e == HttpError.noConnectivity) {
        throw UpdateContactInfoException(AppI18n.current.errorNoInternet);
      }
      throw UpdateContactInfoException(AppI18n.current.errorUnexpected);
    }
  }
}

class UpdateContactInfoException implements Exception {
  final String message;
  const UpdateContactInfoException(this.message);
}
