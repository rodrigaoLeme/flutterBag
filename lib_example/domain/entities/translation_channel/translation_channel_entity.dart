class TranslationChannelEntity {
  final TranslationChannelResultEntity? translationChannel;

  TranslationChannelEntity({
    required this.translationChannel,
  });
}

class TranslationChannelResultEntity {
  final String? externalId;
  final String? eventExternalId;
  final String? text;
  final String? link;

  TranslationChannelResultEntity({
    required this.externalId,
    required this.eventExternalId,
    required this.text,
    required this.link,
  });
}
