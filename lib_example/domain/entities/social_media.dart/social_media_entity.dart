class SocialMediaEntity {
  final SocialMediaResultEntity? socialMedia;

  SocialMediaEntity({
    required this.socialMedia,
  });
}

class SocialMediaResultEntity {
  final String? externalId;
  final String? eventExternalId;
  final String? text;
  final String? link;

  SocialMediaResultEntity({
    required this.externalId,
    required this.eventExternalId,
    required this.text,
    required this.link,
  });
}
