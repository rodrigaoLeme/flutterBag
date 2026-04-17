class ChooseEventEntity {
  final List<ChooseEventResultEntity> result;

  ChooseEventEntity({
    required this.result,
  });
}

class ChooseEventResultEntity {
  final String? externalId;
  final String? name;
  final String? timezone;
  final String? startDate;
  final String? address;
  final String? eventLogo;
  final String? eventColor;

  ChooseEventResultEntity({
    required this.externalId,
    required this.name,
    required this.timezone,
    required this.startDate,
    required this.address,
    required this.eventLogo,
    required this.eventColor,
  });
}
