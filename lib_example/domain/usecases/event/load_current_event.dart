import '../../entities/event/event_entity.dart';

abstract class LoadCurrentEvent {
  Future<EventResultEntity?> load();
}
