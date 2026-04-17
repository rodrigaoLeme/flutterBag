import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/usecases.dart';
import '../../http/http.dart';
import '../../models/models.dart';

class RemoteLoadEditProfile implements LoadEditProfile {
  final String url;
  final HttpClient httpClient;

  RemoteLoadEditProfile({
    required this.url,
    required this.httpClient,
  });

  @override
  Future<EditProfileEntity> load() async {
    try {
      final httpResponse =
          await httpClient.request(url: url, method: HttpMethod.get);
      return RemoteEditProfileModel.fromJson(httpResponse).toEntity();
    } on HttpError catch (error) {
      throw error == HttpError.forbidden
          ? DomainError.accessDenied
          : DomainError.unexpected;
    }
  }
}
