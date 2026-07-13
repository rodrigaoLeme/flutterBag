import '../../../data/http/http_client.dart';
import '../../../domain/usecases/enrollment/save_step_2_usecase.dart';
import '../../../main/flavors.dart';
import '../../../main/i18n/app_i18n.dart';

class RemoteSaveStep2Usecase implements SaveStep2Usecase {
  final HttpClient httpClient;

  const RemoteSaveStep2Usecase({
    required this.httpClient,
  });

  @override
  Future<void> save(SaveStep2Params params) async {
    try {
      await httpClient.request(
        url: '${Flavor.apiBaseUrl}/scholarships/${params.scholarshipId}/step-2',
        method: HttpMethod.put,
        body: params.groupIncome.toJson(),
      );
    } on ApiException catch (e) {
      throw SaveStep2Exception(
        e.fullMessage.isNotEmpty
            ? e.fullMessage
            : AppI18n.current.errorUnexpected,
      );
    } on HttpError catch (e) {
      if (e == HttpError.noConnectivity) {
        throw SaveStep2Exception(AppI18n.current.errorNoInternet);
      }
      throw SaveStep2Exception(AppI18n.current.errorUnexpected);
    }
  }
}

class SaveStep2Exception implements Exception {
  final String message;
  const SaveStep2Exception(this.message);
}
