class ExhibitionEntity {
  final List<ExhibitionResultEntity>? exhibitor;

  ExhibitionEntity({
    required this.exhibitor,
  });

  Map toJson() => {
        'Result': exhibitor?.map((element) => element.toMap()).toList(),
      };
}

class ExhibitionResultEntity {
  final int? id;
  final String? externalId;
  final String? eventExternalId;
  final String? name;
  final String? description;
  final String? division;
  final String? divisionAcronym;
  final String? divisionName;
  final String? type;
  final String? location;
  final String? startTime;
  final String? finalTime;
  final String? timezone;
  final int? fileCount;
  final List<String>? social;
  final String? exhibitorPictureUrl;
  final bool? showTime;
  final List<FilesEntity>? files;
  final String? exhibitorPictureBackgroundColor;

  ExhibitionResultEntity({
    required this.id,
    required this.externalId,
    required this.eventExternalId,
    required this.name,
    required this.description,
    required this.division,
    required this.divisionAcronym,
    required this.divisionName,
    required this.type,
    required this.location,
    required this.startTime,
    required this.finalTime,
    required this.timezone,
    required this.fileCount,
    required this.social,
    required this.exhibitorPictureUrl,
    required this.showTime,
    required this.files,
    required this.exhibitorPictureBackgroundColor,
  });

  Map toMap() => {
        'Id': id,
        'ExternalId': externalId,
        'EventExternalId': eventExternalId,
        'Name': name,
        'Description': description,
        'Division': division,
        'DivisionAcronym': divisionAcronym,
        'DivisionName': divisionName,
        'Type': type,
        'Location': location,
        'StartTime': startTime,
        'FinalTime': finalTime,
        'Timezone': timezone,
        'FileCount': fileCount,
        'Social': social?.map((toElement) => toElement.toString()).toList(),
        'ExhibitorPictureUrl': exhibitorPictureUrl,
        'ShowTime': showTime,
        'Files': files?.map((toElement) => toElement.toMap()).toList(),
        'ExhibitorPictureBackgroundColor': exhibitorPictureBackgroundColor
      };
}

class FilesEntity {
  final String? externalId;
  final String? name;
  final String? storagePath;

  FilesEntity({
    required this.externalId,
    required this.name,
    required this.storagePath,
  });

  Map toMap() => {
        'ExternalId': externalId,
        'Name': name,
        'StoragePath': storagePath,
      };
}
