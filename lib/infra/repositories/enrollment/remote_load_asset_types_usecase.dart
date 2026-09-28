import '../../../data/http/http_client.dart';
import '../../../domain/entities/asset_type_entity.dart';
import '../../../domain/usecases/enrollment/load_asset_types_usecase.dart';
import '../../../main/flavors.dart';
import '../../../main/i18n/app_i18n.dart';

class RemoteLoadAssetTypesUsecase implements LoadAssetTypesUsecase {
  final HttpClient httpClient;

  const RemoteLoadAssetTypesUsecase({required this.httpClient});

  @override
  Future<List<AssetTypeEntity>> load() async {
    try {
      final response = await httpClient.request(
        url: '${Flavor.apiBaseUrl}/v1/asset-types',
        method: HttpMethod.get,
      );

      return (response as List)
          .map((e) => AssetTypeEntity.fromJson(
                Map<String, dynamic>.from(e as Map),
              ))
          .toList();
    } on HttpError catch (e) {
      if (e == HttpError.noConnectivity) {
        throw LoadAssetTypesException(AppI18n.current.errorNoInternet);
      }
      throw LoadAssetTypesException(AppI18n.current.errorUnexpected);
    } on ApiException catch (e) {
      throw LoadAssetTypesException(
        e.title.isNotEmpty ? e.title : AppI18n.current.errorUnexpected,
      );
    }
  }
}
