import '../../entities/special_needs_entity.dart';

abstract class LoadSpecialNeedsUsecase {
  Future<List<SpecialNeedsEntity>> load();
}
