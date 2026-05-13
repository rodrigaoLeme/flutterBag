import '../../../data/http/http_client.dart';
import '../../../data/models/school/remote_school_model.dart';
import '../../../domain/entities/school_entity.dart';
import '../../../domain/usecases/notices/load_schools.dart';
import '../../../main/flavors.dart';
import '../../../main/i18n/app_i18n.dart';

class RemoteLoadSchoolsUsecase implements LoadSchoolsUsecase {
  final HttpClient httpClient;

  const RemoteLoadSchoolsUsecase({required this.httpClient});

  @override
  Future<List<SchoolEntity>> load(LoadSchoolsParams params) async {
    try {
      final response = await httpClient.request(
        url: '${Flavor.apiBaseUrl}/schools',
        method: HttpMethod.get,
        queryParameters: {'year': params.year},
      );

      final list = (response as List)
          .map((e) => RemoteSchoolModel.fromJson(
                Map<String, dynamic>.from(e as Map),
              ).toEntity())
          .toList();

      return list;
    } on HttpError catch (e) {
      if (e == HttpError.noConnectivity) {
        throw LoadSchoolsException(AppI18n.current.errorNoInternet);
      }
      throw LoadSchoolsException(AppI18n.current.errorUnexpected);
    } on ApiException catch (e) {
      throw LoadSchoolsException(
        e.title.isNotEmpty ? e.title : AppI18n.current.errorUnexpected,
      );
    }
  }
}

class LoadSchoolsException implements Exception {
  final String message;
  const LoadSchoolsException(this.message);
}
