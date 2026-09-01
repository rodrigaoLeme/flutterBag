class NationalitiesEntity {
  final String id;
  final String? name;

  const NationalitiesEntity({
    required this.id,
    this.name,
  });

  factory NationalitiesEntity.fromJson(Map<String, dynamic> json) =>
      NationalitiesEntity(
        id: json['id'] as String,
        name: json['name'] as String?,
      );
}
