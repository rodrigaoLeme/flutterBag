class EventEntity {
  final List<EventResultEntity>? event;

  EventEntity({
    required this.event,
  });
}

class EventResultEntity {
  final String? externalId;
  final String? name;
  final String? timezone;
  final String? startDate;
  final String? finalDate;
  final String? description;
  final String? country;
  final String? city;
  final String? address;
  final String? eventColor;
  final String? eventCover;
  final String? eventLogo;
  final String? eventMap;
  final List<EventSectionEntity>? sections;
  final List<SpeakersEntity>? speakers;
  final List<String>? socialMedia;

  EventResultEntity({
    required this.address,
    required this.city,
    required this.country,
    required this.description,
    required this.eventColor,
    required this.eventCover,
    required this.eventLogo,
    required this.externalId,
    required this.finalDate,
    required this.name,
    required this.startDate,
    required this.timezone,
    required this.sections,
    required this.speakers,
    required this.eventMap,
    required this.socialMedia,
  });
}

class EventSectionEntity {
  final String? slug;
  final String? name;
  final String? description;

  EventSectionEntity({
    required this.slug,
    required this.name,
    required this.description,
  });
}

class SpeakersEntity {
  final int? id;
  final String? externalId;
  final String? fullName;
  final String? jobTitle;
  final String? biography;
  final String? photoUrl;
  final String? division;
  final List<String>? social;
  final String? photoBackgroundColor;

  SpeakersEntity({
    required this.id,
    required this.externalId,
    required this.fullName,
    required this.jobTitle,
    required this.biography,
    required this.photoUrl,
    required this.division,
    required this.social,
    required this.photoBackgroundColor,
  });

  Map toJson() => {
        'Id': id,
        'ExternalId': externalId,
        'FullName': fullName,
        'JobTitle': jobTitle,
        'Biography': biography,
        'PhotoUrl': photoUrl,
        'Division': division,
        'Social': social?.map((toElement) => toElement.toString()).toList(),
        'PhotoBackgroundColor': photoBackgroundColor,
      };
}
