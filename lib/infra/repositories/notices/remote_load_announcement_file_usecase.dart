import '../../../data/http/http_client.dart';
import '../../../domain/usecases/notices/load_announcement_file.dart';
import '../../../main/flavors.dart';
import '../../../main/i18n/app_i18n.dart';

class RemoteLoadAnnouncementFileUsecase implements LoadAnnouncementFileUsecase {
  final HttpClient httpClient;

  const RemoteLoadAnnouncementFileUsecase({required this.httpClient});

  @override
  Future<String> load(LoadAnnouncementFileParams params) async {
    try {
      final response = await httpClient.request(
        url: '${Flavor.apiBaseUrl}/announcements/${params.announcementId}/file',
        method: HttpMethod.get,
      );

      final url = response['url'] as String?;
      if (url == null || url.isEmpty) {
        throw LoadAnnouncementFileException(
          AppI18n.current.noticesTermsFileNotFound,
        );
      }
      return url;
    } on HttpError catch (e) {
      if (e == HttpError.notFound) {
        throw LoadAnnouncementFileException(
          AppI18n.current.noticesTermsFileNotFound,
        );
      }
      if (e == HttpError.noConnectivity) {
        throw LoadAnnouncementFileException(
          AppI18n.current.errorNoInternet,
        );
      }
      throw LoadAnnouncementFileException(
        AppI18n.current.errorUnexpected,
      );
    } on ApiException catch (e) {
      throw LoadAnnouncementFileException(
          e.title.isNotEmpty ? e.title : AppI18n.current.errorUnexpected);
    }
  }
}

class LoadAnnouncementFileException implements Exception {
  final String message;
  const LoadAnnouncementFileException(this.message);
}
