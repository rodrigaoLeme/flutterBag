class SchoolGradeEntity {
  final String id;
  final String? name;

  const SchoolGradeEntity({
    required this.id,
    this.name,
  });

  String get displayName => name ?? id;

  factory SchoolGradeEntity.fromJson(Map<String, dynamic> json) {
    final nestedAcademic = _asMap(json['academicCourse']);
    final nestedCourse = _asMap(json['course']);

    final id = json['academicCourseId'] ??
        nestedAcademic?['id'] ??
        json['id'] ??
        json['schoolGradeId'] ??
        json['courseId'] ??
        nestedCourse?['id'];

    final name = json['name'] ??
        json['displayName'] ??
        json['description'] ??
        nestedAcademic?['name'] ??
        nestedAcademic?['displayName'] ??
        nestedCourse?['name'] ??
        nestedCourse?['displayName'];

    return SchoolGradeEntity(
      id: id?.toString() ?? '',
      name: name as String?,
    );
  }

  static List<SchoolGradeEntity> listFrom(dynamic raw) {
    if (raw is Map) {
      final nested = raw['academicCourses'] ??
          raw['schoolCourses'] ??
          raw['courses'] ??
          raw['grades'] ??
          raw['schoolGrades'] ??
          raw['series'] ??
          raw['data'] ??
          raw['items'] ??
          raw['results'];
      if (nested != null) return listFrom(nested);
      return const [];
    }
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((e) => SchoolGradeEntity.fromJson(Map<String, dynamic>.from(e)))
        .where((g) => g.id.isNotEmpty && g.id != 'null')
        .toList();
  }

  static Map<String, dynamic>? _asMap(dynamic value) {
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }
}
