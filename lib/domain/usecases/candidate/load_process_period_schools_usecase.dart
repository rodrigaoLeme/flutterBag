import '../../entities/school_entity.dart';

class LoadProcessPeriodSchoolsParams {
  final String processPeriodId;
  const LoadProcessPeriodSchoolsParams({required this.processPeriodId});
}

abstract class LoadProcessPeriodSchoolsUsecase {
  Future<List<SchoolEntity>> load(LoadProcessPeriodSchoolsParams params);
}

class LoadProcessPeriodSchoolsException implements Exception {
  final String message;
  const LoadProcessPeriodSchoolsException(this.message);
}
