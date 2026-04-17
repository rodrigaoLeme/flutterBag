import '../../../../domain/helpers/helpers.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/get_in_line/load_get_in_line.dart';
import '../../http/http.dart';
import '../../models/models.dart';

class RemoteLoadGetInLine implements LoadGetInLine {
  final String url;
  final HttpClient httpClient;

  RemoteLoadGetInLine({
    required this.httpClient,
    required this.url,
  });

  @override
  Future<GetInLineEntity> load() async {
    try {
      final httpResponse =
          await httpClient.request(url: url, method: HttpMethod.get);
      return RemoteGetInLineModel.fromJson(httpResponse).toEntity();
    } on HttpError catch (error) {
      throw error == HttpError.forbidden
          ? DomainError.accessDenied
          : DomainError.unexpected;
    }
  }
}
