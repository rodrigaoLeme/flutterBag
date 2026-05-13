import '../../../data/http/http_client.dart';
import '../../../data/models/notice/remote_announcement_model.dart';
import '../../../domain/entities/announcement_enums.dart';
import '../../../domain/entities/notice_entity.dart';
import '../../../domain/usecases/notices/load_announcements.dart';
import '../../../main/flavors.dart';
import '../../../main/i18n/app_i18n.dart';

class RemoteLoadAnnouncementsUsecase implements LoadAnnouncementsUsecase {
  final HttpClient httpClient;

  const RemoteLoadAnnouncementsUsecase({required this.httpClient});

  @override
  Future<List<NoticeEntity>> load(LoadAnnouncementsParams params) async {
    try {
      final queryParams = <String, dynamic>{
        'year': params.year,
        'city': params.city,
        'schoolId': params.schoolId,
      };

      if (params.educationLevel != null) {
        queryParams['educationLevel'] = params.educationLevel!.value;
      }

      final response = await httpClient.request(
        url: '${Flavor.apiBaseUrl}/announcements',
        method: HttpMethod.get,
        queryParameters: queryParams,
      );

      final rawList = (response as List)
          .map((e) => RemoteAnnouncementModel.fromJson(
                Map<String, dynamic>.from(e as Map),
              ))
          .toList();

      return _groupAndSort(rawList);
    } on HttpError catch (e) {
      if (e == HttpError.noConnectivity) {
        throw LoadAnnouncementsException(AppI18n.current.errorNoInternet);
      }
      throw LoadAnnouncementsException(AppI18n.current.errorUnexpected);
    } on ApiException catch (e) {
      throw LoadAnnouncementsException(
        e.title.isNotEmpty ? e.title : AppI18n.current.errorUnexpected,
      );
    }
  }

  List<NoticeEntity> _groupAndSort(List<RemoteAnnouncementModel> raw) {
    final editais = raw.where((e) => e.isEdital).toList();
    final additiveTerms = raw.where((e) => !e.isEdital).toList();

    final grouped = editais.map((edital) {
      final terms =
          additiveTerms.map((t) => t.toAdditiveTerm(edital.id)).toList();

      terms.sort((a, b) => (b.editalReleaseDate ?? DateTime(0))
          .compareTo(a.editalReleaseDate ?? DateTime(0)));

      return NoticeEntity(
        id: edital.id,
        title: edital.title ?? '',
        editalNumber: edital.editalNumber,
        editalReleaseDate: edital.editalReleaseDate,
        educationLevel: EducationLevel.fromValue(edital.educationLevel),
        processType: ProcessType.fromValue(edital.processType),
        scholarshipType: ScholarshipType.fromValue(edital.scholarshipType),
        additiveTerms: terms,
      );
    }).toList();

    grouped.sort((a, b) => (b.editalReleaseDate ?? DateTime(0))
        .compareTo(a.editalReleaseDate ?? DateTime(0)));

    return grouped;
  }
}

class LoadAnnouncementsException implements Exception {
  final String message;
  const LoadAnnouncementsException(this.message);
}
