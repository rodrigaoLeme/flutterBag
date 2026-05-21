import '../../../data/http/http_client.dart';
import '../../../domain/usecases/home/load_user_years_usecase.dart';
import '../../../main/flavors.dart';
import '../../../main/i18n/app_i18n.dart';

class RemoteLoadUserYearsUsecase implements LoadUserYearsUsecase {
  final HttpClient httpClient;

  const RemoteLoadUserYearsUsecase({required this.httpClient});

  @override
  Future<List<int>> load() async {
    try {
      final response = await httpClient.request(
        url: '${Flavor.apiBaseUrl}/year-processes/years',
        method: HttpMethod.get,
      );
      return (response as List).map((e) => e as int).toList();
    } on HttpError catch (e) {
      if (e == HttpError.unauthorized || e == HttpError.forbidden) {
        throw Exception(AppI18n.current.loginAccessDenied);
      }
      throw Exception(AppI18n.current.errorUnexpected);
    }
  }
}
