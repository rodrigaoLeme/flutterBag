import '../../entities/dashboard/schedule_entity.dart';

abstract class LoadSchedule {
  Future<ScheduleEntity> load();
}
