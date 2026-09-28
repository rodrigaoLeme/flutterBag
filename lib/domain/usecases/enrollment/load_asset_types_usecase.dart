import '../../entities/asset_type_entity.dart';

abstract class LoadAssetTypesUsecase {
  Future<List<AssetTypeEntity>> load();
}

class LoadAssetTypesException implements Exception {
  final String message;
  const LoadAssetTypesException(this.message);
}
