import '../../entities/occupation_type_entity.dart';

abstract class LoadOccupationTypesUsecase {
  Future<List<OccupationTypeEntity>> load();
}
