import '../../../data/http/http_client.dart';
import '../../../domain/entities/housing_entity.dart';
import '../../../domain/usecases/enrollment/save_step_1_usecase.dart';
import '../../../main/flavors.dart';
import '../../../main/i18n/app_i18n.dart';

class RemoteSaveStep1Usecase implements SaveStep1Usecase {
  final HttpClient httpClient;

  const RemoteSaveStep1Usecase({
    required this.httpClient,
  });

  @override
  Future<String> save(HousingEntity housing) async {
    try {
      final response = await httpClient.request(
        url: '${Flavor.apiBaseUrl}/scholarships/step-1',
        method: HttpMethod.post,
        body: housing.toJson(),
      );

      final scholarshipId = response['id'] as String;

      return scholarshipId;
    } on ApiException catch (e) {
      switch (e.code) {
        case 'Person.NotFound':
          throw SaveStep1Exception(AppI18n.current.errorPersonNotFound);
        case 'ProcessPeriod.NotFound':
        case 'ProcessPeriodInvalid':
          throw SaveStep1Exception(AppI18n.current.errorProcessPeriodInvalid);
        default:
          throw SaveStep1Exception(
            e.fullMessage.isNotEmpty
                ? e.fullMessage
                : AppI18n.current.errorUnexpected,
          );
      }
    } on HttpError catch (e) {
      if (e == HttpError.noConnectivity) {
        throw SaveStep1Exception(AppI18n.current.errorNoInternet);
      }
      throw SaveStep1Exception(AppI18n.current.errorUnexpected);
    }
  }
}

class SaveStep1Exception implements Exception {
  final String message;
  const SaveStep1Exception(this.message);
}
