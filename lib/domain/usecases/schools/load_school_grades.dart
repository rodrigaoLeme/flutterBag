import '../../entities/school_grade_entity.dart';

class LoadSchoolGradesParams {
  final String schoolId;
  final int year;

  const LoadSchoolGradesParams({
    required this.schoolId,
    required this.year,
  });
}

abstract class LoadSchoolGradesUsecase {
  Future<List<SchoolGradeEntity>> load(LoadSchoolGradesParams params);
}
