import '../../../domain/entities/event/event_entity.dart';
import '../../http/http_error.dart';

class RemoteEventModel {
  final List<EventResultModel>? event;

  RemoteEventModel({
    required this.event,
  });

  factory RemoteEventModel.fromJson(Map json) {
    if (!json.containsKey('Result')) {
      throw HttpError.invalidData;
    }
    return RemoteEventModel(
      event: json['Result']
          .map<EventResultModel>(
            (resultEventJson) => EventResultModel.fromJson(resultEventJson),
          )
          .toList(),
    );
  }

  EventEntity toEntity() => EventEntity(
        event:
            event?.map<EventResultEntity>((event) => event.toEntity()).toList(),
      );
}

class EventResultModel {
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
  final List<EventSectionModel>? sections;
  final List<SpeakersModel>? speakers;
  final List<String>? socialMedia;

  EventResultModel({
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

  factory EventResultModel.fromJson(Map json) {
    return EventResultModel(
      address: json['Address'],
      city: json['City'],
      country: json['Country'],
      description: json['Description'],
      eventColor: json['EventColor'],
      eventCover: json['EventCover'],
      eventLogo: json['EventLogo'],
      externalId: json['ExternalId'],
      finalDate: json['FinalDate'],
      name: json['Name'],
      startDate: json['StartDate'],
      timezone: json['Timezone'],
      eventMap: json['EventMap'],
      sections: json['Sections']
          ?.map<EventSectionModel>(
            (sections) => EventSectionModel.fromJson(sections),
          )
          .toList(),
      speakers: json['Speakers']
          ?.map<SpeakersModel>(
            (speakers) => SpeakersModel.fromJson(speakers),
          )
          .toList(),
      socialMedia: json['SocialMedia'] != null
          ? (json['SocialMedia'] as List<dynamic>)
              .map((element) => element.toString())
              .toList()
          : null,
    );
  }

  EventResultEntity toEntity() => EventResultEntity(
        address: address,
        city: city,
        country: country,
        description: description,
        eventColor: eventColor,
        eventCover: eventCover,
        eventLogo: eventLogo,
        externalId: externalId,
        finalDate: finalDate,
        name: name,
        startDate: startDate,
        timezone: timezone,
        eventMap: eventMap,
        sections: sections
            ?.map<EventSectionEntity>((event) => event.toEntity())
            .toList(),
        speakers: speakers
            ?.map<SpeakersEntity>((speaker) => speaker.toEntity())
            .toList(),
        socialMedia: socialMedia,
      );
}

class EventSectionModel {
  final String? slug;
  final String? name;
  final String? description;

  EventSectionModel({
    required this.slug,
    required this.name,
    required this.description,
  });

  factory EventSectionModel.fromJson(Map json) {
    return EventSectionModel(
      slug: json['Slug'],
      name: json['Name'],
      description: json['Description'],
    );
  }

  EventSectionEntity toEntity() => EventSectionEntity(
        slug: slug,
        name: name,
        description: description,
      );
}

class SpeakersModel {
  final int? id;
  final String? externalId;
  final String? fullName;
  final String? jobTitle;
  final String? biography;
  final String? photoUrl;
  final String? division;
  final List<String>? social;
  final String? photoBackgroundColor;

  SpeakersModel({
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

  factory SpeakersModel.fromJson(Map json) {
    return SpeakersModel(
      id: json['Id'],
      externalId: json['ExternalId'],
      fullName: json['FullName'],
      jobTitle: json['JobTitle'],
      biography: json['Biography'],
      photoUrl: json['PhotoUrl'],
      division: json['Division'],
      social: json['Social'] != null
          ? (json['Social'] as List<dynamic>)
              .map((element) => element.toString())
              .toList()
          : null,
      photoBackgroundColor: json['PhotoBackgroundColor'],
    );
  }

  SpeakersEntity toEntity() => SpeakersEntity(
        id: id,
        externalId: externalId,
        fullName: fullName,
        jobTitle: jobTitle,
        biography: biography,
        photoUrl: photoUrl,
        division: division,
        social: social,
        photoBackgroundColor: photoBackgroundColor,
      );

  Map toJson() => {
        'Id': id,
        'ExternalId': externalId,
        'FullName': fullName,
        'JobTitle': jobTitle,
        'Biography': biography,
        'PhotoUrl': photoUrl,
        'Division': division,
        'Social': social,
        'PhotoBackgroundColor': photoBackgroundColor
      };
}
