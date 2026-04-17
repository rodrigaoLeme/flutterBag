class TransportEntity {
  final TransportResultEntity? transport;

  TransportEntity({
    required this.transport,
  });
}

class TransportResultEntity {
  final String? externalId;
  final String? eventExternalId;
  final String? text;
  final String? link;

  TransportResultEntity({
    required this.externalId,
    required this.eventExternalId,
    required this.text,
    required this.link,
  });
}
