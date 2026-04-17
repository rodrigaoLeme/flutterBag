class NewsEntity {
  final String? eventExternalId;
  final String? externalId;
  final NewsDetailsEntity? details;
  final int? newsFont;
  final bool? isPinned;
  final bool? isShow;

  NewsEntity({
    required this.eventExternalId,
    required this.externalId,
    required this.details,
    required this.newsFont,
    required this.isPinned,
    required this.isShow,
  });
}

class NewsDetailsEntity {
  final String? card;
  final String? title;
  final String? lead;
  final String? image;
  final String? date;
  final String? tag;
  final String? link;
  final String? coverPhotoUrl;
  final String? homePhotoUrl;
  final String? description;

  NewsDetailsEntity({
    required this.card,
    required this.title,
    required this.lead,
    required this.image,
    required this.date,
    required this.tag,
    required this.link,
    required this.coverPhotoUrl,
    required this.homePhotoUrl,
    required this.description,
  });
}
