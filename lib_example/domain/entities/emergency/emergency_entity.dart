class EmergencyEntity {
  final List<EmergencyResultEntity> result;

  EmergencyEntity({
    required this.result,
  });
}

class EmergencyResultEntity {
  final int? id;
  final String? externalId;
  final int? eventId;
  final String? eventExternalId;
  final String? type;
  final String? title;
  final String? description;
  final String? information;
  final int? order;

  EmergencyResultEntity({
    required this.id,
    required this.externalId,
    required this.eventId,
    required this.eventExternalId,
    required this.type,
    required this.title,
    required this.description,
    required this.information,
    required this.order,
  });
}
