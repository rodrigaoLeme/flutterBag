import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/event/event_entity.dart';
import '../../../domain/entities/spiritual/spiritual_entity.dart';
import '../../helpers/ event_schedule_compressor.dart';
import '../../http/http.dart';
import '../event/remote_event_model.dart';

class RemoteSpiritualModel {
  final List<DevotionalModel>? devotional;
  final List<MusicModel>? music;
  final PrayerRoomModel? prayerRoom;

  RemoteSpiritualModel({
    required this.devotional,
    required this.music,
    required this.prayerRoom,
  });

  factory RemoteSpiritualModel.fromDocument(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    try {
      final data = snapshot.data();

      if (data == null) {
        return RemoteSpiritualModel(
          devotional: [],
          music: [],
          prayerRoom: null,
        );
      }

      final raw = data['Result'];

      Map<String, dynamic>? decodedResult;

      if (raw is String) {
        try {
          decodedResult =
              EventScheduleCompressor.decompress(raw) as Map<String, dynamic>;
        } catch (_) {
          decodedResult = jsonDecode(raw);
        }
      } else if (raw is Map<String, dynamic>) {
        decodedResult = raw;
      }

      final devotional = (decodedResult?['Devotional'] as List?)
          ?.map((item) {
            final itemJson = item as Map<String, dynamic>?;
            if (itemJson != null) {
              return DevotionalModel.fromJson(itemJson);
            }
          })
          .whereType<DevotionalModel>()
          .toSet()
          .toList();

      final music = (decodedResult?['Music'] as List?)
          ?.map<MusicModel>(
            (music) => MusicModel.fromJson(music),
          )
          .toList();

      final prayerRoomJson =
          decodedResult?['PrayerRoom'] as Map<String, dynamic>?;

      final prayerRoom = prayerRoomJson != null
          ? PrayerRoomModel.fromJson(prayerRoomJson)
          : null;

      return RemoteSpiritualModel(
        devotional: devotional,
        music: music,
        prayerRoom: prayerRoom,
      );
    } catch (e) {
      throw HttpError.invalidData;
    }
  }
}

class DevotionalModel {
  final int? id;
  final String? externalId;
  final String? eventExternalId;
  final String? title;
  final String? photoUrl;
  final String? dayPeriod;
  final String? selectedDay;
  final int? devotionalsCount;
  final int? speakersCount;
  final List<SpeakersModel>? speakers;
  final List<DevotionalsModel>? devotionals;

  DevotionalModel({
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

  factory DevotionalModel.fromJson(Map json) {
    return DevotionalModel(
      id: json['Id'],
      externalId: json['ExternalId'],
      eventExternalId: json['EventExternalId'],
      title: json['Title'],
      photoUrl: json['PhotoUrl'],
      dayPeriod: json['DayPeriod'],
      selectedDay: json['SelectedDay'],
      devotionalsCount: json['DevotionalsCount'],
      speakersCount: json['SpeakersCount'],
      speakers: json['Speakers']
          ?.map<SpeakersModel>(
            (speakers) => SpeakersModel.fromJson(speakers),
          )
          .toList(),
      devotionals: json['Devotionals']
          ?.map<DevotionalsModel>(
            (devotionals) => DevotionalsModel.fromJson(devotionals),
          )
          .toList(),
    );
  }

  SpiritualResultEntity toEntity() => SpiritualResultEntity(
        id: id,
        externalId: externalId,
        eventExternalId: eventExternalId,
        title: title,
        photoUrl: photoUrl,
        dayPeriod: dayPeriod,
        selectedDay: selectedDay,
        devotionalsCount: devotionalsCount,
        speakersCount: speakersCount,
        speakers: speakers
            ?.map<SpeakersEntity>((speaker) => speaker.toEntity())
            .toList(),
        devotionals: devotionals
            ?.map<DevotionalsEntity>((devotionals) => devotionals.toEntity())
            .toList(),
      );
}

class DevotionalsModel {
  final String? language;
  final String? link;
  final int? order;
  final bool? isDefault;

  DevotionalsModel({
    required this.language,
    required this.link,
    required this.order,
    required this.isDefault,
  });

  factory DevotionalsModel.fromJson(Map json) {
    return DevotionalsModel(
      language: json['Language'],
      link: json['Link'],
      order: json['Order'],
      isDefault: json['IsDefault'],
    );
  }

  DevotionalsEntity toEntity() => DevotionalsEntity(
        language: language,
        link: link,
        order: order,
        isDefault: isDefault,
      );
}

class MusicModel {
  final String? externalId;
  final String? eventExternalId;
  final String? name;
  final String? text;
  final String? link;
  final String? thumbnail;
  final int? order;

  MusicModel({
    required this.externalId,
    required this.eventExternalId,
    required this.name,
    required this.text,
    required this.link,
    required this.thumbnail,
    required this.order,
  });

  factory MusicModel.fromJson(Map json) {
    return MusicModel(
      externalId: json['ExternalId'],
      eventExternalId: json['EventExternalId'],
      name: json['Name'],
      text: json['Text'],
      link: json['Link'],
      thumbnail: json['Thumbnail'],
      order: json['Order'],
    );
  }

  MusicEntity toEntity() => MusicEntity(
        externalId: externalId,
        eventExternalId: eventExternalId,
        name: name,
        text: text,
        link: link,
        thumbnail: thumbnail,
        order: order,
      );
}

class PrayerRoomModel {
  final String? externalId;
  final String? location;
  final String? text;
  final String? startTime;
  final String? finalTime;

  PrayerRoomModel({
    required this.externalId,
    required this.location,
    required this.text,
    required this.startTime,
    required this.finalTime,
  });

  factory PrayerRoomModel.fromJson(Map? json) {
    return PrayerRoomModel(
      externalId: json?['ExternalId'],
      location: json?['Location'],
      text: json?['Text'],
      startTime: json?['StartTime'],
      finalTime: json?['FinalTime'],
    );
  }

  PrayerRoomEntity toEntity() => PrayerRoomEntity(
        externalId: externalId,
        location: location,
        text: text,
        startTime: startTime,
        finalTime: finalTime,
      );
}
