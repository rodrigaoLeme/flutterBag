import '../../../data/http/http_client.dart';
import '../../../domain/entities/academic_course_entity.dart';
import '../../../domain/usecases/candidate/load_academic_courses_usecase.dart';
import '../../../main/flavors.dart';
import '../../../main/i18n/app_i18n.dart';

class RemoteLoadAcademicCoursesUsecase implements LoadAcademicCoursesUsecase {
  final HttpClient httpClient;

  const RemoteLoadAcademicCoursesUsecase({required this.httpClient});

  @override
  Future<List<AcademicCourseEntity>> load(
      LoadAcademicCoursesParams params) async {
    try {
      final response = await httpClient.request(
        url:
            '${Flavor.apiBaseUrl}/v1/process-periods/${params.processPeriodId}/schools/${params.schoolId}/academic-courses',
        method: HttpMethod.get,
      );

      final list = (response as List)
          .map((e) => AcademicCourseEntity.fromJson(
                Map<String, dynamic>.from(e as Map),
              ))
          .toList();

      // Ordenação: courseLevel crescente → name alfabético
      list.sort((a, b) {
        final levelCompare = (a.courseLevel ?? 0).compareTo(b.courseLevel ?? 0);
        if (levelCompare != 0) return levelCompare;
        return (a.name ?? '').compareTo(b.name ?? '');
      });

      return list;
    } on HttpError catch (e) {
      if (e == HttpError.noConnectivity) {
        throw LoadAcademicCoursesException(AppI18n.current.errorNoInternet);
      }
      throw LoadAcademicCoursesException(AppI18n.current.errorUnexpected);
    } on ApiException catch (e) {
      throw LoadAcademicCoursesException(
        e.title.isNotEmpty ? e.title : AppI18n.current.errorUnexpected,
      );
    }
  }
}
