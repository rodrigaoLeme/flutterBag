import '../../../data/http/http_client.dart';
import '../../../data/models/home/remote_process_period_model.dart';
import '../../../domain/entities/process_period_entity.dart';
import '../../../domain/usecases/home/load_available_process_periods_usecase.dart';
import '../../../main/flavors.dart';
import '../../../main/i18n/app_i18n.dart';

class RemoteLoadAvailableProcessPeriodsUsecase
    implements LoadAvailableProcessPeriodsUsecase {
  final HttpClient httpClient;

  const RemoteLoadAvailableProcessPeriodsUsecase({required this.httpClient});

  @override
  Future<List<ProcessPeriodAvailableEntity>> load(int year) async {
    try {
      final response = await httpClient.request(
        url: '${Flavor.apiBaseUrl}/process-periods/available',
        method: HttpMethod.get,
        queryParameters: {'year': year},
      );

      return (response as List)
          .map((e) => RemoteProcessPeriodModel.fromJson(
                Map<String, dynamic>.from(e as Map),
              ).toEntity())
          .toList();
    } on HttpError catch (e) {
      if (e == HttpError.noConnectivity) {
        throw Exception(AppI18n.current.errorNoInternet);
      }
      throw Exception(AppI18n.current.errorUnexpected);
    }
  }
}
