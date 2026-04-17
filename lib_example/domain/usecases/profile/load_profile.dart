import '../../entities/entities.dart';

abstract class LoadProfile {
  Future<ProfileEntity> load();
}
