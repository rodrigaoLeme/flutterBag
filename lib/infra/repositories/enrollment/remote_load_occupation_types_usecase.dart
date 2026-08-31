import '../../../data/http/http_client.dart';
import '../../../domain/entities/occupation_type_entity.dart';
import '../../../domain/usecases/enrollment/load_occupation_types_usecase.dart';
import '../../../main/flavors.dart';
import '../../../main/i18n/app_i18n.dart';

class RemoteLoadOccupationTypesUsecase implements LoadOccupationTypesUsecase {
  final HttpClient httpClient;

  const RemoteLoadOccupationTypesUsecase({required this.httpClient});

  @override
  Future<List<OccupationTypeEntity>> load() async {
    try {
      final response = await httpClient.request(
        url: '${Flavor.apiBaseUrl}/ocupation-types',
        method: HttpMethod.get,
      );

      final list = (response as List)
          .map((e) => OccupationTypeEntity.fromJson(
                Map<String, dynamic>.from(e as Map),
              ))
          .toList();

      // Ordena pelo campo order
      list.sort((a, b) => a.order.compareTo(b.order));

      return list;
    } on HttpError catch (e) {
      if (e == HttpError.noConnectivity) {
        throw LoadOccupationTypesException(AppI18n.current.errorNoInternet);
      }
      throw LoadOccupationTypesException(AppI18n.current.errorUnexpected);
    } on ApiException catch (e) {
      throw LoadOccupationTypesException(
        e.title.isNotEmpty ? e.title : AppI18n.current.errorUnexpected,
      );
    }
  }
}

class LoadOccupationTypesException implements Exception {
  final String message;
  const LoadOccupationTypesException(this.message);
}
