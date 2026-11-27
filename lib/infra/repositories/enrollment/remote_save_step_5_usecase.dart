import '../../../data/http/http_client.dart';
import '../../../domain/usecases/enrollment/save_step_5_usecase.dart';
import '../../../main/flavors.dart';
import '../../../main/i18n/app_i18n.dart';

class RemoteSaveStep5Usecase implements SaveStep5Usecase {
  final HttpClient httpClient;

  const RemoteSaveStep5Usecase({
    required this.httpClient,
  });

  @override
  Future<void> save(SaveStep5Params params) async {
    try {
      await httpClient.request(
        url:
            '${Flavor.apiBaseUrl}/v1/scholarships/${params.scholarshipId}/step-5',
        method: HttpMethod.put,
        body: const {},
      );
    } on SaveStep5Exception {
      rethrow;
    } on ApiException catch (e) {
      throw SaveStep5Exception(
        e.fullMessage.isNotEmpty
            ? e.fullMessage
            : AppI18n.current.errorUnexpected,
      );
    } on HttpError catch (e) {
      if (e == HttpError.noConnectivity) {
        throw SaveStep5Exception(AppI18n.current.errorNoInternet);
      }
      throw SaveStep5Exception(AppI18n.current.errorUnexpected);
    }
  }
}

class SaveStep5Exception implements Exception {
  final String message;
  const SaveStep5Exception(this.message);
}
