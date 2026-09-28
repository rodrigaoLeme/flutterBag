import '../../../data/http/http_client.dart';
import '../../../domain/usecases/enrollment/set_scholarship_step_usecase.dart';
import '../../../main/flavors.dart';
import '../../../main/i18n/app_i18n.dart';

class RemoteSetScholarshipStepUsecase implements SetScholarshipStepUsecase {
  final HttpClient httpClient;

  const RemoteSetScholarshipStepUsecase({required this.httpClient});

  @override
  Future<void> set(SetScholarshipStepParams params) async {
    try {
      await httpClient.request(
        url:
            '${Flavor.apiBaseUrl}/v1/scholarships/${params.scholarshipId}/step',
        method: HttpMethod.put,
        body: {'step': params.step},
      );
    } on ApiException catch (e) {
      throw SetScholarshipStepException(
        e.fullMessage.isNotEmpty
            ? e.fullMessage
            : AppI18n.current.errorUnexpected,
      );
    } on HttpError catch (e) {
      if (e == HttpError.noConnectivity) {
        throw SetScholarshipStepException(AppI18n.current.errorNoInternet);
      }
      throw SetScholarshipStepException(AppI18n.current.errorUnexpected);
    }
  }
}
