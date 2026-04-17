import '../event/event_entity.dart';
import '../exhibition/exhibition_entity.dart';

class AgendaEntity {
  final List<EventScheduleResultEntity>? schedule;

  AgendaEntity({
    required this.schedule,
  });

  Map toJson() => {
        'Result': schedule?.map((element) => element.toMap()).toList(),
      };
}

class EventScheduleResultEntity {
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
  final List<SpeakersEntity>? speakers;
  final List<FilesEntity>? files;

  EventScheduleResultEntity({
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
        'Files': files?.map((toElement) => toElement.toMap()).toList(),
      };
}
