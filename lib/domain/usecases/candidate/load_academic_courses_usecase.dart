import '../../entities/academic_course_entity.dart';

class LoadAcademicCoursesParams {
  final String processPeriodId;
  final String schoolId;

  const LoadAcademicCoursesParams({
    required this.processPeriodId,
    required this.schoolId,
  });
}

abstract class LoadAcademicCoursesUsecase {
  Future<List<AcademicCourseEntity>> load(LoadAcademicCoursesParams params);
}

class LoadAcademicCoursesException implements Exception {
  final String message;
  const LoadAcademicCoursesException(this.message);
}
