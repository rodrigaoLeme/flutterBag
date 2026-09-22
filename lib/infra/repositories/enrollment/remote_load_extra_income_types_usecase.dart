import '../../../data/http/http_client.dart';
import '../../../domain/entities/extra_income_type_entity.dart';
import '../../../domain/usecases/enrollment/load_extra_income_types_usecase.dart';
import '../../../main/flavors.dart';
import '../../../main/i18n/app_i18n.dart';

class RemoteLoadExtraIncomeTypesUsecase implements LoadExtraIncomeTypesUsecase {
  final HttpClient httpClient;

  const RemoteLoadExtraIncomeTypesUsecase({required this.httpClient});

  @override
  Future<List<ExtraIncomeTypeEntity>> load() async {
    try {
      final response = await httpClient.request(
        url: '${Flavor.apiBaseUrl}/v1/extra-income-types',
        method: HttpMethod.get,
      );

      return (response as List)
          .map((e) => ExtraIncomeTypeEntity.fromJson(
                Map<String, dynamic>.from(e as Map),
              ))
          .toList();
    } on HttpError catch (e) {
      if (e == HttpError.noConnectivity) {
        throw LoadExtraIncomeTypesException(AppI18n.current.errorNoInternet);
      }
      throw LoadExtraIncomeTypesException(AppI18n.current.errorUnexpected);
    } on ApiException catch (e) {
      throw LoadExtraIncomeTypesException(
        e.title.isNotEmpty ? e.title : AppI18n.current.errorUnexpected,
      );
    }
  }
}
