class SponsorEntity {
  final List<SponsorResultEntity>? sponsor;

  SponsorEntity({
    required this.sponsor,
  });
}

class SponsorResultEntity {
  final String? externalId;
  final String? eventExternalId;
  final String? name;
  final String? link;
  final String? photoUrl;

  SponsorResultEntity({
    required this.externalId,
    required this.eventExternalId,
    required this.name,
    required this.link,
    required this.photoUrl,
  });
}
