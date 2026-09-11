class AuthorizationStageEntity {
  final int stage;
  final DateTime? originalDeadline;
  final DateTime? effectiveDeadline;
  final bool isExceptional;
  final bool canPerform;
  final String? blockCode;
  final String? blockMessage;

  const AuthorizationStageEntity({
    required this.stage,
    this.originalDeadline,
    this.effectiveDeadline,
    required this.isExceptional,
    required this.canPerform,
    this.blockCode,
    this.blockMessage,
  });

  factory AuthorizationStageEntity.fromJson(Map<String, dynamic> json) =>
      AuthorizationStageEntity(
        stage: _parseInt(json['stage']) ?? 0,
        originalDeadline: _parseDate(json['originalDeadline']),
        effectiveDeadline: _parseDate(json['effectiveDeadline']),
        isExceptional: json['isExceptional'] as bool? ?? false,
        canPerform: json['canPerform'] as bool? ?? false,
        blockCode: json['blockCode'] as String?,
        blockMessage: json['blockMessage'] as String?,
      );

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }
}
