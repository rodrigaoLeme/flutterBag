import '../../../domain/entities/business/business_entity.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/business/load_business.dart';
import '../../http/http.dart';
import '../../models/business/remote_business_model.dart';

class RemoteLoadBusiness implements LoadBusiness {
  final String url;
  final HttpClient httpClient;

  RemoteLoadBusiness({
    required this.url,
    required this.httpClient,
  });

  @override
  Future<BusinessEntity> load() async {
    try {
      final httpResponse =
          await httpClient.request(url: url, method: HttpMethod.get);
      return RemoteBusinessModel.fromJson(httpResponse).toEntity();
    } on HttpError catch (error) {
      throw error == HttpError.forbidden
          ? DomainError.accessDenied
          : DomainError.unexpected;
    }
  }
}
