import '../../../data/http/http_client.dart';
import '../../../data/models/home/remote_scholarship_model.dart';
import '../../../domain/entities/scholarship_entity.dart';
import '../../../domain/usecases/home/load_year_scholarships_usecase.dart';
import '../../../main/flavors.dart';
import '../../../main/i18n/app_i18n.dart';

class RemoteLoadYearScholarshipsUsecase implements LoadYearScholarshipsUsecase {
  final HttpClient httpClient;

  const RemoteLoadYearScholarshipsUsecase({required this.httpClient});

  @override
  Future<List<ScholarshipEntity>> load(int year) async {
    try {
      final response = await httpClient.request(
        url: '${Flavor.apiBaseUrl}/year-processes/$year/scholarships',
        method: HttpMethod.get,
      );
      return (response as List)
          .map((e) => RemoteScholarshipModel.fromJson(
                Map<String, dynamic>.from(e as Map),
              ).toEntity())
          .toList();
    } on HttpError catch (e) {
      if (e == HttpError.unauthorized || e == HttpError.forbidden) {
        throw Exception(AppI18n.current.loginAccessDenied);
      }
      throw Exception(AppI18n.current.errorUnexpected);
    }
  }
}
