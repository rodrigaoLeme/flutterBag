import '../../../data/http/http_client.dart';
import '../../../domain/entities/announcement_enums.dart';
import '../../../domain/entities/available_announcement_entity.dart';
import '../../../domain/entities/school_grade_entity.dart';
import '../../../domain/usecases/notices/load_announcement_schools.dart';
import '../../../main/flavors.dart';
import '../../../main/i18n/app_i18n.dart';

class RemoteLoadAnnouncementSchoolsUsecase
    implements LoadAnnouncementSchoolsUsecase {
  final HttpClient httpClient;

  const RemoteLoadAnnouncementSchoolsUsecase({required this.httpClient});

  @override
  Future<List<AnnouncementSchoolEntity>> load(
    LoadAnnouncementSchoolsParams params,
  ) async {
    try {
      final eligible = <String, AnnouncementSchoolEntity>{};
      _mergeInto(eligible, params.knownSchools);

      final processPeriodId = params.processPeriodId;
      if (processPeriodId != null && processPeriodId.isNotEmpty) {
        _mergeInto(
          eligible,
          await _tryLoad(
            url:
                '${Flavor.apiBaseUrl}/v1/process-periods/$processPeriodId/schools',
            queryParameters: const {'enabled': true},
          ),
        );
        _mergeInto(
          eligible,
          await _tryLoad(
            url:
                '${Flavor.webApiBaseUrl}/v2/process-periods/$processPeriodId/schools',
            queryParameters: const {'enabled': true},
          ),
        );
      }

      final announcementId = params.announcementId;
      if (announcementId != null && announcementId.isNotEmpty) {
        _mergeInto(
          eligible,
          await _tryLoad(
            url: '${Flavor.apiBaseUrl}/v1/announcements/$announcementId',
          ),
        );
        _mergeInto(
          eligible,
          await _tryLoad(
            url: '${Flavor.webApiBaseUrl}/v2/announcements/$announcementId',
          ),
        );
      }

      if (eligible.isEmpty) return const [];

      final catalog = await _tryLoad(
        url: '${Flavor.apiBaseUrl}/v1/schools',
        queryParameters: {'year': params.year},
      );
      final catalogById = {for (final school in catalog) school.id: school};

      final enriched = eligible.values
          .map((school) => _enrich(school, catalogById[school.id]))
          .toList();

      return _matching(enriched, params.educationLevel);
    } on HttpError catch (e) {
      if (e == HttpError.noConnectivity) {
        throw LoadAnnouncementSchoolsException(AppI18n.current.errorNoInternet);
      }
      throw LoadAnnouncementSchoolsException(AppI18n.current.errorUnexpected);
    } on ApiException catch (e) {
      throw LoadAnnouncementSchoolsException(
        e.title.isNotEmpty ? e.title : AppI18n.current.errorUnexpected,
      );
    }
  }

  void _mergeInto(
    Map<String, AnnouncementSchoolEntity> target,
    List<AnnouncementSchoolEntity> schools,
  ) {
    for (final school in schools) {
      final current = target[school.id];
      if (current == null) {
        target[school.id] = school;
        continue;
      }
      target[school.id] = current.copyWith(
        name: current.name ?? school.name,
        city: current.city ?? school.city,
        educationLevel: current.educationLevel ?? school.educationLevel,
        grades: current.grades.isNotEmpty ? current.grades : school.grades,
      );
    }
  }

  AnnouncementSchoolEntity _enrich(
    AnnouncementSchoolEntity school,
    AnnouncementSchoolEntity? catalog,
  ) {
    if (catalog == null) return school;
    return school.copyWith(
      name: school.name ?? catalog.name,
      city: school.city ?? catalog.city,
      educationLevel: school.educationLevel ?? catalog.educationLevel,
      grades: school.grades.isNotEmpty ? school.grades : catalog.grades,
    );
  }

  List<AnnouncementSchoolEntity> _matching(
    List<AnnouncementSchoolEntity> schools,
    EducationLevel? level,
  ) {
    if (level == null) return schools;
    return schools
        .where((school) => school.matchesEducationLevel(level))
        .toList();
  }

  Future<List<AnnouncementSchoolEntity>> _tryLoad({
    required String url,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await httpClient.request(
        url: url,
        method: HttpMethod.get,
        queryParameters: queryParameters,
      );
      return _parseSchools(response);
    } on HttpError catch (e) {
      if (e == HttpError.notFound ||
          e == HttpError.unauthorized ||
          e == HttpError.forbidden) {
        return const [];
      }
      rethrow;
    } on ApiException {
      return const [];
    }
  }

  List<AnnouncementSchoolEntity> _parseSchools(dynamic response) {
    if (response is List) {
      return response
          .whereType<Map>()
          .map((e) => _schoolFromJson(Map<String, dynamic>.from(e)))
          .whereType<AnnouncementSchoolEntity>()
          .toList();
    }

    if (response is Map) {
      final json = Map<String, dynamic>.from(response);
      final nested = json['announcement'];
      final raw = json['schools'] ??
          json['processPeriodSchools'] ??
          (nested is Map ? nested['schools'] : null);
      if (raw is List) {
        return raw
            .whereType<Map>()
            .map((e) => _schoolFromJson(Map<String, dynamic>.from(e)))
            .whereType<AnnouncementSchoolEntity>()
            .toList();
      }
    }

    return const [];
  }

  AnnouncementSchoolEntity? _schoolFromJson(Map<String, dynamic> json) {
    if (json['disabled'] == true || json['enabled'] == false) return null;

    final nested = json['school'] is Map
        ? Map<String, dynamic>.from(json['school'] as Map)
        : null;
    final source = nested ?? json;
    final id = (json['schoolId'] ?? json['id'] ?? source['id'])?.toString();
    if (id == null || id.isEmpty) return null;

    final grades = SchoolGradeEntity.listFrom(json);
    return AnnouncementSchoolEntity(
      id: id,
      name: (json['name'] ?? source['name']) as String?,
      city: json['city'] as String? ??
          source['city'] as String? ??
          _cityFromAddress(json['address']) ??
          _cityFromAddress(source['address']),
      educationLevel: _educationLevelFrom(json) ?? _educationLevelFrom(source),
      grades: grades.isNotEmpty ? grades : SchoolGradeEntity.listFrom(source),
    );
  }

  String? _cityFromAddress(dynamic address) {
    if (address is! Map) return null;
    return address['city'] as String?;
  }

  EducationLevel? _educationLevelFrom(Map<String, dynamic> json) {
    final nested = json['school'];
    final raw = json['educationLevel'] ??
        json['schoolType'] ??
        (nested is Map
            ? nested['educationLevel'] ?? nested['schoolType']
            : null);
    final value = raw is int
        ? raw
        : raw is num
            ? raw.toInt()
            : int.tryParse(raw?.toString() ?? '');
    if (value == null) return null;
    try {
      return EducationLevel.fromValue(value);
    } catch (_) {
      return null;
    }
  }
}

class LoadAnnouncementSchoolsException implements Exception {
  final String message;
  const LoadAnnouncementSchoolsException(this.message);
}
