import 'authorization_stage_entity.dart';

class AuthorizationCapabilitiesEntity {
  final String scholarshipId;
  final String responsiblePersonId;
  final List<AuthorizationStageEntity> stages;

  const AuthorizationCapabilitiesEntity({
    required this.scholarshipId,
    required this.responsiblePersonId,
    this.stages = const [],
  });

  factory AuthorizationCapabilitiesEntity.fromJson(Map<String, dynamic> json) =>
      AuthorizationCapabilitiesEntity(
        scholarshipId: json['scholarshipId'] as String? ?? '',
        responsiblePersonId: json['responsiblePersonId'] as String? ?? '',
        stages: (json['stages'] as List?)
                ?.map((e) => AuthorizationStageEntity.fromJson(
                    Map<String, dynamic>.from(e as Map)))
                .toList() ??
            [],
      );

  AuthorizationStageEntity? stageFor(int? completedStep) {
    final targetStage = (completedStep != null && completedStep >= 4) ? 3 : 2;
    try {
      return stages.firstWhere((s) => s.stage == targetStage);
    } catch (_) {
      return null;
    }
  }
}
