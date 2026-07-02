import '../../../data/http/http_client.dart';
import '../../../domain/entities/school_grade_entity.dart';
import '../../../domain/usecases/schools/load_school_grades.dart';
import '../../../main/flavors.dart';
import '../../../main/i18n/app_i18n.dart';

class RemoteLoadSchoolGradesUsecase implements LoadSchoolGradesUsecase {
  final HttpClient httpClient;

  const RemoteLoadSchoolGradesUsecase({required this.httpClient});

  @override
  Future<List<SchoolGradeEntity>> load(LoadSchoolGradesParams params) async {
    try {
      final response = await httpClient.request(
        url: '${Flavor.apiBaseUrl}/schools/${params.schoolId}/grades',
        method: HttpMethod.get,
        queryParameters: {'year': params.year},
      );

      return (response as List)
          .map(
            (e) => SchoolGradeEntity(
              id: (e as Map)['id'] as String,
              name: e['name'] as String?,
            ),
          )
          .toList();
    } on HttpError catch (e) {
      if (e == HttpError.noConnectivity) {
        throw LoadSchoolGradesException(AppI18n.current.errorNoInternet);
      }
      throw LoadSchoolGradesException(AppI18n.current.errorUnexpected);
    } on ApiException catch (e) {
      throw LoadSchoolGradesException(
        e.title.isNotEmpty ? e.title : AppI18n.current.errorUnexpected,
      );
    }
  }
}

class LoadSchoolGradesException implements Exception {
  final String message;
  const LoadSchoolGradesException(this.message);
}
