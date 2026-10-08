class AcademicCourseEntity {
  final String id;
  final String? name;
  final int? courseLevel;

  const AcademicCourseEntity({
    required this.id,
    this.name,
    this.courseLevel,
  });

  factory AcademicCourseEntity.fromJson(Map<String, dynamic> json) =>
      AcademicCourseEntity(
        id: json['id'] as String,
        name: json['name'] as String?,
        courseLevel: json['courseLevel'] as int?,
      );
}
