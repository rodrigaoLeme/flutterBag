import '../../entities/school_grade_entity.dart';

class LoadSchoolGradesParams {
  final String schoolId;
  final int year;
  final String? processPeriodId;

  const LoadSchoolGradesParams({
    required this.schoolId,
    required this.year,
    this.processPeriodId,
  });
}

abstract class LoadSchoolGradesUsecase {
  Future<List<SchoolGradeEntity>> load(LoadSchoolGradesParams params);
}
