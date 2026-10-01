import '../../../data/http/http_client.dart';
import '../../../domain/usecases/enrollment/cancel_scholarship_usecase.dart';
import '../../../main/flavors.dart';
import '../../../main/i18n/app_i18n.dart';

class RemoteCancelScholarshipUsecase implements CancelScholarshipUsecase {
  final HttpClient httpClient;

  const RemoteCancelScholarshipUsecase({required this.httpClient});

  @override
  Future<void> cancel(CancelScholarshipParams params) async {
    try {
      await httpClient.request(
        url:
            '${Flavor.apiBaseUrl}/v1/scholarships/${params.scholarshipId}/cancel',
        method: HttpMethod.put,
        body: {
          'cancelObservation': params.cancelObservation,
        },
      );
    } on ApiException catch (e) {
      throw CancelScholarshipException(
        e.fullMessage.isNotEmpty
            ? e.fullMessage
            : AppI18n.current.errorUnexpected,
      );
    } on HttpError catch (e) {
      if (e == HttpError.noConnectivity) {
        throw CancelScholarshipException(AppI18n.current.errorNoInternet);
      }
      throw CancelScholarshipException(AppI18n.current.errorUnexpected);
    }
  }
}
