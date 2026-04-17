import '../../../../domain/helpers/helpers.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/usecases.dart';
import '../../http/http.dart';
import '../../models/models.dart';

class RemoteLoadStLouis implements LoadStLouis {
  final String url;
  final HttpClient httpClient;

  RemoteLoadStLouis({
    required this.httpClient,
    required this.url,
  });

  @override
  Future<StLouisEntity> load() async {
    try {
      final httpResponse =
          await httpClient.request(url: url, method: HttpMethod.get);
      return RemoteStLouisModel.fromJson(httpResponse).toEntity();
    } on HttpError catch (error) {
      throw error == HttpError.forbidden
          ? DomainError.accessDenied
          : DomainError.unexpected;
    }
  }
}
