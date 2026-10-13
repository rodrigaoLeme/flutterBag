import '../../../data/http/http_client.dart';
import '../../../domain/usecases/enrollment/save_step_4_usecase.dart';
import '../../../main/flavors.dart';
import '../../../main/i18n/app_i18n.dart';

class RemoteSaveStep4Usecase implements SaveStep4Usecase {
  final HttpClient httpClient;

  const RemoteSaveStep4Usecase({
    required this.httpClient,
  });

  @override
  Future<void> save(SaveStep4Params params) async {
    try {
      await httpClient.request(
        url:
            '${Flavor.apiBaseUrl}/v1/scholarships/${params.scholarshipId}/step-4',
        method: HttpMethod.put,
        body: const {},
      );
    } on SaveStep4Exception {
      rethrow;
    } on ApiException catch (e) {
      throw SaveStep4Exception(
        e.fullMessage.isNotEmpty
            ? e.fullMessage
            : AppI18n.current.errorUnexpected,
      );
    } on HttpError catch (e) {
      if (e == HttpError.noConnectivity) {
        throw SaveStep4Exception(AppI18n.current.errorNoInternet);
      }
      throw SaveStep4Exception(AppI18n.current.errorUnexpected);
    }
  }
}

class SaveStep4Exception implements Exception {
  final String message;
  const SaveStep4Exception(this.message);
}
