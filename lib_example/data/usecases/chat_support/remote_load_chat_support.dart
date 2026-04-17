import '../../../../domain/helpers/helpers.dart';
import '../../../domain/entities/entities.dart';
import '../../../domain/usecases/usecases.dart';
import '../../http/http.dart';
import '../../models/models.dart';

class RemoteLoadChatSupport implements LoadChatSupport {
  final String url;
  final HttpClient httpClient;

  RemoteLoadChatSupport({
    required this.httpClient,
    required this.url,
  });

  @override
  Future<ChatSupportEntity> load() async {
    try {
      final httpResponse =
          await httpClient.request(url: url, method: HttpMethod.get);
      return RemoteChatSupportModel.fromJson(httpResponse).toEntity();
    } on HttpError catch (error) {
      throw error == HttpError.forbidden
          ? DomainError.accessDenied
          : DomainError.unexpected;
    }
  }
}
