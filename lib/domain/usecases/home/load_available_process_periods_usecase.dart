import '../../entities/process_period_entity.dart';

abstract class LoadAvailableProcessPeriodsUsecase {
  Future<List<ProcessPeriodAvailableEntity>> load(int year);
}
