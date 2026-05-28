import '../../../data/http/http_client.dart';
import '../../../domain/usecases/enrollment/lookup_zip_code_usecase.dart';
import '../../../main/flavors.dart';

class RemoteLookupZipCodeUsecase implements LookupZipCodeUsecase {
  final HttpClient httpClient;

  const RemoteLookupZipCodeUsecase({required this.httpClient});

  @override
  Future<ZipCodeEntity> lookup(String cep) async {
    try {
      final response = await httpClient.request(
        url: '${Flavor.apiBaseUrl}/address/cep/$cep',
        method: HttpMethod.get,
      );

      final street = response['street'] as String?;
      final city = response['city'] as String?;
      if (street == null && city == null) {
        throw const ZipCodeNotFoundException();
      }

      return ZipCodeEntity(
        cep: response['cep'] as String? ?? cep,
        street: street,
        neighborhood: response['neighborhood'] as String?,
        city: city,
        state: response['state'] as String?,
      );
    } on ApiException {
      throw const ZipCodeNotFoundException();
    } on HttpError catch (e) {
      if (e == HttpError.notFound) throw const ZipCodeNotFoundException();
      rethrow;
    }
  }
}
