import '../../entities/nationalities_entity.dart';

abstract class LoadNationalitiesUsecase {
  Future<List<NationalitiesEntity>> load();
}
