import '../../../data/http/http_client.dart';
import '../../../domain/entities/announcement_enums.dart';
import '../../../domain/entities/school_entity.dart';
import '../../../domain/usecases/candidate/load_process_period_schools_usecase.dart';
import '../../../main/flavors.dart';
import '../../../main/i18n/app_i18n.dart';

class RemoteLoadProcessPeriodSchoolsUsecase
    implements LoadProcessPeriodSchoolsUsecase {
  final HttpClient httpClient;

  const RemoteLoadProcessPeriodSchoolsUsecase({required this.httpClient});

  @override
  Future<List<SchoolEntity>> load(LoadProcessPeriodSchoolsParams params) async {
    try {
      final response = await httpClient.request(
        url:
            '${Flavor.apiBaseUrl}/v1/process-periods/${params.processPeriodId}/schools',
        method: HttpMethod.get,
      );

      return (response as List).map((e) {
        final json = Map<String, dynamic>.from(e as Map);
        return SchoolEntity(
          id: json['id'] as String,
          name: json['name'] as String? ?? '',
          city: json['city'] as String? ?? '',
          state: '',
          educationLevel: EducationLevel.basic,
        );
      }).toList();
    } on HttpError catch (e) {
      if (e == HttpError.noConnectivity) {
        throw LoadProcessPeriodSchoolsException(
            AppI18n.current.errorNoInternet);
      }
      throw LoadProcessPeriodSchoolsException(AppI18n.current.errorUnexpected);
    } on ApiException catch (e) {
      throw LoadProcessPeriodSchoolsException(
        e.title.isNotEmpty ? e.title : AppI18n.current.errorUnexpected,
      );
    }
  }
}
