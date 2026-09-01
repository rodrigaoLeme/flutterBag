class SpecialNeedsEntity {
  final String id;
  final String? name;

  const SpecialNeedsEntity({
    required this.id,
    this.name,
  });

  factory SpecialNeedsEntity.fromJson(Map<String, dynamic> json) =>
      SpecialNeedsEntity(
        id: json['id'] as String,
        name: json['name'] as String?,
      );
}
