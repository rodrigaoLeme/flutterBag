class BroadcastEntity {
  final List<BroadcastResultEntity>? result;

  BroadcastEntity({
    required this.result,
  });
}

class BroadcastResultEntity {
  final String? externalId;
  final String? title;
  final String? link;
  final String? language;
  final String? dayPeriod;
  final String? selectedDay;
  final int? order;

  BroadcastResultEntity({
    required this.externalId,
    required this.title,
    required this.link,
    required this.language,
    required this.dayPeriod,
    required this.selectedDay,
    required this.order,
  });
}
