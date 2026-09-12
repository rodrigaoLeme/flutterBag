class ExtraIncomeEntity {
  final String id;
  final String? familyMemberId;
  final String? extraIncomeTypeId;
  final String? description;
  final double? amount;

  const ExtraIncomeEntity({
    required this.id,
    this.familyMemberId,
    this.extraIncomeTypeId,
    this.description,
    this.amount,
  });

  factory ExtraIncomeEntity.fromJson(Map<String, dynamic> json) =>
      ExtraIncomeEntity(
        id: json['id'] as String,
        familyMemberId: json['familyMemberId'] as String?,
        extraIncomeTypeId: json['extraIncomeTypeId'] as String?,
        description: json['description'] as String?,
        amount: _parseDouble(json['amount']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'familyMemberId': familyMemberId,
        'extraIncomeTypeId': extraIncomeTypeId,
        'description': description,
        'amount': amount,
      };

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}
