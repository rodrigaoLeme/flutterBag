import '../../../data/http/http_client.dart';
import '../../../domain/usecases/enrollment/save_step_3_usecase.dart';
import '../../../main/flavors.dart';
import '../../../main/i18n/app_i18n.dart';

class RemoteSaveStep3Usecase implements SaveStep3Usecase {
  final HttpClient httpClient;

  const RemoteSaveStep3Usecase({
    required this.httpClient,
  });

  @override
  Future<void> save(SaveStep3Params params) async {
    try {
      await httpClient.request(
        url:
            '${Flavor.apiBaseUrl}/v1/scholarships/${params.scholarshipId}/step-3',
        method: HttpMethod.put,
        body: params.expenses.toJson(),
      );
    } on ApiException catch (e) {
      throw SaveStep3Exception(
        e.fullMessage.isNotEmpty
            ? e.fullMessage
            : AppI18n.current.errorUnexpected,
      );
    } on HttpError catch (e) {
      if (e == HttpError.noConnectivity) {
        throw SaveStep3Exception(AppI18n.current.errorNoInternet);
      }
      throw SaveStep3Exception(AppI18n.current.errorUnexpected);
    }
  }
}

class SaveStep3Exception implements Exception {
  final String message;
  const SaveStep3Exception(this.message);
}
