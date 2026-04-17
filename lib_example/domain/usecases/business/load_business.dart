import '../../entities/business/business_entity.dart';

abstract class LoadBusiness {
  Future<BusinessEntity> load();
}
