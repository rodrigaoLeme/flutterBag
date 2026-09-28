class AssetTypeEntity {
  final int id;
  final String? name;
  final String? group;

  const AssetTypeEntity({
    required this.id,
    this.name,
    this.group,
  });

  factory AssetTypeEntity.fromJson(Map<String, dynamic> json) =>
      AssetTypeEntity(
        id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
        name: json['assetTypeName'] as String?,
        group: json['assetTypeGroup'] as String?,
      );
}
