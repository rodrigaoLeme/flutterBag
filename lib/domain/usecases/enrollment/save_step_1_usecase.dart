import '../../entities/housing_entity.dart';

abstract class SaveStep1Usecase {
  Future<String> save(HousingEntity housing);
}
