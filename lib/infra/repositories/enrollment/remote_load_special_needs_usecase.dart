import '../../../data/http/http_client.dart';
import '../../../domain/entities/special_needs_entity.dart';
import '../../../domain/usecases/enrollment/load_special_needs_usecase.dart';
import '../../../main/flavors.dart';
import '../../../main/i18n/app_i18n.dart';

class RemoteLoadSpecialNeedsUsecase implements LoadSpecialNeedsUsecase {
  final HttpClient httpClient;

  const RemoteLoadSpecialNeedsUsecase({required this.httpClient});

  @override
  Future<List<SpecialNeedsEntity>> load() async {
    try {
      final response = await httpClient.request(
        url: '${Flavor.apiBaseUrl}/special-needs',
        method: HttpMethod.get,
      );

      final list = (response as List)
          .map((e) => SpecialNeedsEntity.fromJson(
                Map<String, dynamic>.from(e as Map),
              ))
          .toList();

      return list;
    } on HttpError catch (e) {
      if (e == HttpError.noConnectivity) {
        throw LoadSpecialNeedsException(AppI18n.current.errorNoInternet);
      }
      throw LoadSpecialNeedsException(AppI18n.current.errorUnexpected);
    } on ApiException catch (e) {
      throw LoadSpecialNeedsException(
        e.title.isNotEmpty ? e.title : AppI18n.current.errorUnexpected,
      );
    }
  }
}

class LoadSpecialNeedsException implements Exception {
  final String message;
  const LoadSpecialNeedsException(this.message);
}
