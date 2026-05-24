import '../../../data/http/http_client.dart';
import '../../../data/models/notice/remote_available_announcement_model.dart';
import '../../../domain/entities/available_announcement_entity.dart';
import '../../../domain/usecases/notices/load_available_announcements.dart';
import '../../../main/flavors.dart';
import '../../../main/i18n/app_i18n.dart';

class RemoteLoadAvailableAnnouncementsUsecase
    implements LoadAvailableAnnouncementsUsecase {
  final HttpClient httpClient;

  const RemoteLoadAvailableAnnouncementsUsecase({required this.httpClient});

  @override
  Future<List<AvailableAnnouncementEntity>> load(
      LoadAvailableAnnouncementsParams params) async {
    try {
      final queryParams = <String, dynamic>{
        'year': params.year,
        'city': params.city,
        'schoolId': params.schoolId,
        'processType': params.processType.value,
      };

      if (params.educationLevel != null) {
        queryParams['educationLevel'] = params.educationLevel!.value;
      }

      final response = await httpClient.request(
        url: '${Flavor.apiBaseUrl}/announcements',
        method: HttpMethod.get,
        queryParameters: queryParams,
      );

      return (response as List)
          .map((e) => RemoteAvailableAnnouncementModel.fromJson(
                Map<String, dynamic>.from(e as Map),
              ).toEntity())
          .toList();
    } on HttpError catch (e) {
      if (e == HttpError.noConnectivity) {
        throw LoadAvailableAnnouncementsException(
            AppI18n.current.errorNoInternet);
      }
      throw LoadAvailableAnnouncementsException(
          AppI18n.current.errorUnexpected);
    } on ApiException catch (e) {
      throw LoadAvailableAnnouncementsException(
        e.title.isEmpty ? e.title : AppI18n.current.errorUnexpected,
      );
    }
  }
}

class LoadAvailableAnnouncementsException implements Exception {
  final String message;
  const LoadAvailableAnnouncementsException(this.message);
}
