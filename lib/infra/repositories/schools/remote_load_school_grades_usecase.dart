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
      final processPeriodId = params.processPeriodId;
      final attempts = <({String url, Map<String, dynamic>? query})>[];

      if (processPeriodId != null && processPeriodId.isNotEmpty) {
        attempts.addAll([
          (
            url:
                '${Flavor.webApiBaseUrl}/v2/schools/${params.schoolId}/process-periods/$processPeriodId/academic-courses',
            query: {'active': true},
          ),
          (
            url:
                '${Flavor.webApiBaseUrl}/v2/process-periods/$processPeriodId/courses',
            query: {'schoolId': params.schoolId},
          ),
        ]);
      }

      attempts.addAll([
        (
          url:
              '${Flavor.webApiBaseUrl}/v2/schools/${params.schoolId}/academic-courses',
          query: {'year': params.year},
        ),
        (
          url:
              '${Flavor.webApiBaseUrl}/v2/schools/${params.schoolId}/school-courses',
          query: null,
        ),
      ]);

      for (final attempt in attempts) {
        final grades = await _tryLoad(
          url: attempt.url,
          queryParameters: attempt.query,
        );
        if (grades.isNotEmpty) return grades;
      }

      return const [];
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

  Future<List<SchoolGradeEntity>> _tryLoad({
    required String url,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await httpClient.request(
        url: url,
        method: HttpMethod.get,
        queryParameters: queryParameters,
      );
      return SchoolGradeEntity.listFrom(response);
    } on HttpError catch (e) {
      if (e == HttpError.notFound ||
          e == HttpError.unauthorized ||
          e == HttpError.forbidden) {
        return const [];
      }
      rethrow;
    } on ApiException {
      return const [];
    }
  }
}

class LoadSchoolGradesException implements Exception {
  final String message;
  const LoadSchoolGradesException(this.message);
}
