import '../../../data/http/http_client.dart';
import '../../../domain/usecases/enrollment/save_step_6_usecase.dart';
import '../../../main/flavors.dart';
import '../../../main/i18n/app_i18n.dart';

class RemoteSaveStep6Usecase implements SaveStep6Usecase {
  final HttpClient httpClient;

  const RemoteSaveStep6Usecase({
    required this.httpClient,
  });

  @override
  Future<void> save(SaveStep6Params params) async {
    try {
      await httpClient.request(
        url:
            '${Flavor.apiBaseUrl}/v1/scholarships/${params.scholarshipId}/step-6',
        method: HttpMethod.put,
        body: {
          'acceptTerm': true,
          'password': params.password,
        },
      );
    } on ApiException catch (e) {
      throw SaveStep6Exception(
        e.fullMessage.isNotEmpty
            ? e.fullMessage
            : AppI18n.current.errorUnexpected,
      );
    } on HttpError catch (e) {
      if (e == HttpError.noConnectivity) {
        throw SaveStep6Exception(AppI18n.current.errorNoInternet);
      }
      throw SaveStep6Exception(AppI18n.current.errorUnexpected);
    }
  }
}

class SaveStep6Exception implements Exception {
  final String message;
  const SaveStep6Exception(this.message);
}
