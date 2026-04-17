import '../event/event_entity.dart';

class SpiritualEntity {
  final List<SpiritualResultEntity>? devotional;
  final List<MusicEntity>? music;
  final PrayerRoomEntity? prayerRoom;

  SpiritualEntity({
    required this.devotional,
    required this.music,
    required this.prayerRoom,
  });
}

class SpiritualResultEntity {
  final int? id;
  final String? externalId;
  final String? eventExternalId;
  final String? title;
  final String? photoUrl;
  final String? dayPeriod;
  final String? selectedDay;
  final int? devotionalsCount;
  final int? speakersCount;
  final List<SpeakersEntity>? speakers;
  final List<DevotionalsEntity>? devotionals;

  SpiritualResultEntity({
    required this.id,
    required this.externalId,
    required this.eventExternalId,
    required this.title,
    required this.photoUrl,
    required this.dayPeriod,
    required this.selectedDay,
    required this.devotionalsCount,
    required this.speakersCount,
    required this.speakers,
    required this.devotionals,
  });
}

class DevotionalsEntity {
  final String? language;
  final String? link;
  final int? order;
  final bool? isDefault;

  DevotionalsEntity({
    required this.language,
    required this.link,
    required this.order,
    required this.isDefault,
  });
}

class MusicEntity {
  final String? externalId;
  final String? eventExternalId;
  final String? name;
  final String? text;
  final String? link;
  final String? thumbnail;
  final int? order;

  MusicEntity({
    required this.externalId,
    required this.eventExternalId,
    required this.name,
    required this.text,
    required this.link,
    required this.thumbnail,
    required this.order,
  });
}

class PrayerRoomEntity {
  final String? externalId;
  final String? location;
  final String? text;
  final String? startTime;
  final String? finalTime;

  PrayerRoomEntity({
    required this.externalId,
    required this.location,
    required this.text,
    required this.startTime,
    required this.finalTime,
  });
}
