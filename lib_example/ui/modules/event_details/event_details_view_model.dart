import '../../../data/models/event/remote_event_model.dart';
import '../../../domain/entities/event/event_entity.dart';
import '../../helpers/extensions/string_extension.dart';

class EventDetailsViewModel {
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
  final List<SpeakersViewModel>? speakers;
  final List<String>? socialMedia;

  EventDetailsViewModel({
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
    required this.eventMap,
    required this.timezone,
    required this.speakers,
    required this.socialMedia,
  });
}

class EventDetailsViewModelFactory {
  static Future<EventDetailsViewModel> make(EventResultModel? model) async {
    return EventDetailsViewModel(
      address: model?.address,
      city: model?.city,
      country: model?.country,
      description: await model?.description?.translate(),
      eventColor: model?.eventColor,
      eventCover: model?.eventCover,
      eventLogo: model?.eventLogo,
      externalId: model?.externalId,
      finalDate: model?.finalDate,
      name: model?.name,
      startDate: model?.startDate,
      timezone: model?.timezone,
      eventMap: model?.eventMap,
      speakers: model?.speakers != null
          ? await Future.wait(
              model!.speakers!.map(
                (speaker) async => SpeakersViewModel(
                  id: speaker.id,
                  externalId: speaker.externalId,
                  fullName: await speaker.fullName?.translate(),
                  jobTitle: await speaker.jobTitle?.translate(),
                  biography: await speaker.biography?.translate(),
                  photoUrl: speaker.photoUrl,
                  division: speaker.division,
                  social: speaker.social,
                  photoBackgroundColor: speaker.photoBackgroundColor,
                ),
              ),
            )
          : [],
      socialMedia: model?.socialMedia,
    );
  }
}

class SpeakersViewModel {
  final int? id;
  final String? externalId;
  final String? fullName;
  final String? jobTitle;
  final String? biography;
  final String? photoUrl;
  final String? division;
  final List<String>? social;
  final String? photoBackgroundColor;

  SpeakersViewModel({
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

  String get personInitial {
    final parts = (fullName ?? '').trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '';
    return (parts.first[0] + (parts.length > 1 ? parts.last[0] : ''))
        .toUpperCase();
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
  double get minBottomSheetSize {
    if (biography?.isEmpty == true) {
      return 0.4;
    }
    if ((biography?.length ?? 0) > 300) {
      return 0.75;
    }
    return 0.50;
  }
}
