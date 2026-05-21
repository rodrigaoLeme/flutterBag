import '../../entities/scholarship_entity.dart';

abstract class LoadYearScholarshipsUsecase {
  Future<List<ScholarshipEntity>> load(int year);
}
