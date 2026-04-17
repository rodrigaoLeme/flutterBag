import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/entities.dart';
import '../../http/http.dart';

class RemoteExhibitionModel {
  final List<ExhibitionResultModel>? exhibitor;

  RemoteExhibitionModel({
    required this.exhibitor,
  });

  factory RemoteExhibitionModel.fromDocument(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    try {
      final data = snapshot.data();
      final decodedResult = jsonDecode(data?['Result']) as List;

      final exhibitor = decodedResult
          .map((item) =>
              ExhibitionResultModel.fromJson(item as Map<String, dynamic>))
          .toList();
      return RemoteExhibitionModel(exhibitor: exhibitor);
    } catch (e) {
      throw HttpError.invalidData;
    }
  }

  factory RemoteExhibitionModel.fromJson(Map json) {
    if (!json.containsKey('Result')) {
      throw HttpError.invalidData;
    }
    return RemoteExhibitionModel(
      exhibitor: json['Result']
          .map<ExhibitionResultModel>(
            (resultEventJson) =>
                ExhibitionResultModel.fromJson(resultEventJson),
          )
          .toList(),
    );
  }

  ExhibitionEntity toEntity() => ExhibitionEntity(
        exhibitor: exhibitor
            ?.map<ExhibitionResultEntity>((event) => event.toEntity())
            .toList(),
      );
}

class ExhibitionResultModel {
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
  final List<FilesModel>? files;
  final String? exhibitorPictureBackgroundColor;

  ExhibitionResultModel({
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

  factory ExhibitionResultModel.fromJson(Map json) {
    if (!json.containsKey('ExternalId')) {
      throw HttpError.invalidData;
    }
    return ExhibitionResultModel(
      id: json['Id'],
      externalId: json['ExternalId'],
      eventExternalId: json['EventExternalId'],
      name: json['Name'],
      description: json['Description'],
      division: json['Division'],
      divisionAcronym: json['DivisionAcronym'],
      divisionName: json['DivisionName'],
      type: json['Type'],
      location: json['Location'],
      startTime: json['StartTime'],
      finalTime: json['FinalTime'],
      timezone: json['Timezone'],
      fileCount: json['FileCount'],
      social: json['Social'] != null
          ? (json['Social'] as List<dynamic>)
              .map((element) => element.toString())
              .toList()
          : null,
      exhibitorPictureUrl: json['ExhibitorPictureUrl'],
      showTime: json['ShowTime'],
      files: json['Files']
          ?.map<FilesModel>(
            (files) => FilesModel.fromJson(files),
          )
          .toList(),
      exhibitorPictureBackgroundColor: json['ExhibitorPictureBackgroundColor'],
    );
  }

  ExhibitionResultEntity toEntity() => ExhibitionResultEntity(
        id: id,
        externalId: externalId,
        eventExternalId: eventExternalId,
        name: name,
        description: description,
        division: division,
        divisionAcronym: divisionAcronym,
        divisionName: divisionName,
        type: type,
        location: location,
        startTime: startTime,
        finalTime: finalTime,
        timezone: timezone,
        fileCount: fileCount,
        social: social,
        exhibitorPictureUrl: exhibitorPictureUrl,
        showTime: showTime,
        files: files?.map<FilesEntity>((files) => files.toEntity()).toList(),
        exhibitorPictureBackgroundColor: exhibitorPictureBackgroundColor,
      );
}

class FilesModel {
  final String? externalId;
  final String? name;
  final String? storagePath;

  FilesModel({
    required this.externalId,
    required this.name,
    required this.storagePath,
  });

  factory FilesModel.fromJson(Map json) {
    return FilesModel(
      externalId: json['ExternalId'],
      name: json['Name'],
      storagePath: json['StoragePath'],
    );
  }

  FilesEntity toEntity() => FilesEntity(
        externalId: externalId,
        name: name,
        storagePath: storagePath,
      );

  Map toJson() => {
        'externalId': externalId,
        'name': name,
        'storagePath': storagePath,
      };
}

enum ExhibitionTypeModel {
  pdf('Pdf'),
  png('PNG'),
  jpeg('JPEG'),
  jpg('JPG'),
  image('Image'),
  mp4('mp4');

  const ExhibitionTypeModel(this.type);
  final String type;

  String get iconAsset {
    switch (this) {
      case ExhibitionTypeModel.pdf:
        return 'lib/ui/assets/images/icon/file-pdf-regular.svg';
      case ExhibitionTypeModel.mp4:
        return 'lib/ui/assets/images/icon/audio_file.svg';
      default:
        return 'lib/ui/assets/images/icon/file-image-regular.svg';
    }
  }

  bool get isLink {
    switch (this) {
      case ExhibitionTypeModel.pdf:
      case ExhibitionTypeModel.image:
      case ExhibitionTypeModel.jpeg:
      case ExhibitionTypeModel.png:
      case ExhibitionTypeModel.jpg:
      case ExhibitionTypeModel.mp4:
        return true;
    }
  }

  static ExhibitionTypeModel fromType(String? type) {
    return ExhibitionTypeModel.values.firstWhere(
      (e) => e.type.toLowerCase() == type?.toLowerCase(),
      orElse: () => ExhibitionTypeModel.pdf,
    );
  }
}
