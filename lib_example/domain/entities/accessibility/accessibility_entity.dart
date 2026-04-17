class AccessibilityEntity {
  final AccessibilityResultEntity? accessibility;

  AccessibilityEntity({
    required this.accessibility,
  });
}

class AccessibilityResultEntity {
  final String? externalId;
  final String? eventExternalId;
  final String? text;
  final String? link;

  AccessibilityResultEntity({
    required this.externalId,
    required this.eventExternalId,
    required this.text,
    required this.link,
  });
}
