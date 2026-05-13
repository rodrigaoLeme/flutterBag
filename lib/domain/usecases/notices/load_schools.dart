import '../../entities/school_entity.dart';

class LoadSchoolsParams {
  final String year;
  const LoadSchoolsParams({required this.year});
}

abstract class LoadSchoolsUsecase {
  Future<List<SchoolEntity>> load(LoadSchoolsParams params);
}
