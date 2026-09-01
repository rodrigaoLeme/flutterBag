import '../../../data/http/http_client.dart';
import '../../../domain/entities/nationalities_entity.dart';
import '../../../domain/usecases/enrollment/load_nationalities_usecase.dart';
import '../../../main/flavors.dart';
import '../../../main/i18n/app_i18n.dart';

class RemoteLoadNationalitiesUsecase implements LoadNationalitiesUsecase {
  final HttpClient httpClient;

  const RemoteLoadNationalitiesUsecase({required this.httpClient});

  @override
  Future<List<NationalitiesEntity>> load() async {
    try {
      final response = await httpClient.request(
        url: '${Flavor.apiBaseUrl}/nationalities',
        method: HttpMethod.get,
      );

      final list = (response as List)
          .map((e) => NationalitiesEntity.fromJson(
                Map<String, dynamic>.from(e as Map),
              ))
          .toList();

      return list;
    } on HttpError catch (e) {
      if (e == HttpError.noConnectivity) {
        throw LoadNationalitiesException(AppI18n.current.errorNoInternet);
      }
      throw LoadNationalitiesException(AppI18n.current.errorUnexpected);
    } on ApiException catch (e) {
      throw LoadNationalitiesException(
        e.title.isNotEmpty ? e.title : AppI18n.current.errorUnexpected,
      );
    }
  }
}

class LoadNationalitiesException implements Exception {
  final String message;
  const LoadNationalitiesException(this.message);
}
