class StudentsEntity {
  final String id;
  final String name;
  final int? status;

  const StudentsEntity({
    required this.id,
    required this.name,
    this.status,
  });

  factory StudentsEntity.fromJson(Map<String, dynamic> json) => StudentsEntity(
        id: json['id'] as String,
        name: json['name'] as String,
        status: json['status'] as int?,
      );
}
