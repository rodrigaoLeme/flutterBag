import '../../../data/http/http_client.dart';
import '../../../domain/entities/person_entity.dart';
import '../../../domain/usecases/enrollment/lookup_person_usecase.dart';
import '../../../main/flavors.dart';
import '../../../main/i18n/app_i18n.dart';

class RemoteLookupPersonUsecase implements LookupPersonUsecase {
  final HttpClient httpClient;

  const RemoteLookupPersonUsecase({required this.httpClient});

  @override
  Future<PersonEntity?> lookup(String cpf) async {
    try {
      final cleanCpf = cpf.replaceAll(RegExp(r'\D'), '');
      final response = await httpClient.request(
        url: '${Flavor.apiBaseUrl}/persons/$cleanCpf',
        method: HttpMethod.get,
      );

      return PersonEntity.fromJson(
        Map<String, dynamic>.from(response as Map),
      );
    } on HttpError catch (e) {
      if (e == HttpError.notFound) return null;
      if (e == HttpError.noConnectivity) {
        throw LookupPersonException(AppI18n.current.errorNoInternet);
      }
      throw LookupPersonException(AppI18n.current.errorUnexpected);
    }
  }
}
