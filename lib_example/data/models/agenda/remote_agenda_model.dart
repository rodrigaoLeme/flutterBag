import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/agenda/agenda_entity.dart';
import '../../../domain/entities/event/event_entity.dart';
import '../../../domain/entities/exhibition/exhibition_entity.dart';
import '../../helpers/ event_schedule_compressor.dart';
import '../../http/http.dart';
import '../event/remote_event_model.dart';
import '../exhibition/remote_exhibition_model.dart';

class RemoteAgendaModel {
  final List<RemoteEventScheduleModel>? schedule;

  RemoteAgendaModel({
    required this.schedule,
  });

  factory RemoteAgendaModel.fromDocument(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    try {
      final data = snapshot.data();
      if (data == null) {
        return RemoteAgendaModel(schedule: []);
      }
      print(data['ResultV2']);
      final compressed = EventScheduleCompressor.decompress(data['ResultV2']);
      final decodedSchedule = compressed;

      final schedule = decodedSchedule
          .map((item) =>
              RemoteEventScheduleModel.fromJson(item as Map<String, dynamic>))
          .toList();
      return RemoteAgendaModel(schedule: schedule);
    } catch (e) {
      throw HttpError.invalidData;
    }
  }

  factory RemoteAgendaModel.fromJson(Map json) {
    if (!json.containsKey('Result')) {
      throw HttpError.invalidData;
    }
    return RemoteAgendaModel(
      schedule: json['Result']
          .map<RemoteEventScheduleModel>(
            (resultEventJson) =>
                RemoteEventScheduleModel.fromJson(resultEventJson),
          )
          .toList(),
    );
  }

  AgendaEntity toEntity() => AgendaEntity(
        schedule: schedule
            ?.map<EventScheduleResultEntity>((event) => event.toEntity())
            .toList(),
      );

  Map toJson() => {
        'Result': schedule?.map((element) => element.toMap()).toList(),
      };
}

class RemoteEventScheduleModel {
  final String? externalId;
  final String? eventExternalId;
  final String? name;
  final String? description;
  final String? location;
  final String? translationChannel;
  final String? timezone;
  final String? startTime;
  final String? finalTime;
  final String? type;
  final int? group;
  final String? groupName;
  final List<SpeakersModel>? speakers;
  final List<FilesModel>? files;

  RemoteEventScheduleModel({
    required this.externalId,
    required this.eventExternalId,
    required this.name,
    required this.description,
    required this.location,
    required this.translationChannel,
    required this.timezone,
    required this.startTime,
    required this.finalTime,
    required this.type,
    required this.group,
    required this.groupName,
    required this.speakers,
    required this.files,
  });

  factory RemoteEventScheduleModel.fromJson(Map json) {
    if (!json.containsKey('ExternalId')) {
      throw HttpError.invalidData;
    }
    return RemoteEventScheduleModel(
      externalId: json['ExternalId'],
      eventExternalId: json['EventExternalId'],
      name: json['Name'],
      description: json['Description'],
      location: json['Location'],
      translationChannel: json['TranslationChannel'],
      timezone: json['Timezone'],
      startTime: json['StartTime'],
      finalTime: json['FinalTime'],
      type: json['Type'],
      group: json['Group'],
      groupName: json['GroupName'],
      speakers: json['Speakers']
          ?.map<SpeakersModel>(
            (speakers) => SpeakersModel.fromJson(speakers),
          )
          .toList(),
      files: json['Files']
          ?.map<FilesModel>(
            (files) => FilesModel.fromJson(files),
          )
          .toList(),
    );
  }

  EventScheduleResultEntity toEntity() => EventScheduleResultEntity(
        externalId: externalId,
        eventExternalId: eventExternalId,
        name: name,
        description: description,
        location: location,
        translationChannel: translationChannel,
        timezone: timezone,
        startTime: startTime,
        finalTime: finalTime,
        type: type,
        group: group,
        groupName: groupName,
        speakers: speakers
            ?.map<SpeakersEntity>((speaker) => speaker.toEntity())
            .toList(),
        files: files?.map<FilesEntity>((files) => files.toEntity()).toList(),
      );

  Map toMap() => {
        'ExternalId': externalId,
        'EventExternalId': eventExternalId,
        'Name': name,
        'Description': description,
        'Location': location,
        'TranslationChannel': translationChannel,
        'Timezone': timezone,
        'StartTime': startTime,
        'FinalTime': finalTime,
        'Type': type,
        'Group': group,
        'GroupName': groupName,
        'Speakers': speakers?.map((toElement) => toElement.toJson()).toList(),
        'Files': files?.map((toElement) => toElement.toJson()).toList()
      };
}

enum ResourcesTypeModel {
  pdf('Pdf'),
  image('Image');

  const ResourcesTypeModel(this.type);
  final String type;

  String get iconAsset {
    switch (this) {
      case ResourcesTypeModel.pdf:
        return 'lib/ui/assets/images/icon/file-pdf-regular.svg';
      case ResourcesTypeModel.image:
        return 'lib/ui/assets/images/icon/file-image-regular.svg';
    }
  }

  bool get isLink {
    switch (this) {
      case ResourcesTypeModel.pdf:
      case ResourcesTypeModel.image:
        return true;
    }
  }

  static ResourcesTypeModel fromType(String? type) {
    return ResourcesTypeModel.values.firstWhere(
      (e) => e.type == type,
      orElse: () => ResourcesTypeModel.pdf,
    );
  }
}
