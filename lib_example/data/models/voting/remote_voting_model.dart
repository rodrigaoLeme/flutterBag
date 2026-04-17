import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/entities.dart';
import '../../http/http.dart';

class VotingResultModel {
  final List<RemoteVotingModel>? votings;

  VotingResultModel({
    required this.votings,
  });

  factory VotingResultModel.fromDocument(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    try {
      final data = snapshot.data();
      final decodedResult = jsonDecode(data?['Result']) as List;

      final votings = decodedResult
          .map((item) =>
              RemoteVotingModel.fromJson(item as Map<String, dynamic>))
          .toList();
      return VotingResultModel(votings: votings);
    } catch (e) {
      return VotingResultModel(votings: []);
    }
  }
}

class RemoteVotingModel {
  final String? externalId;
  final int? eventId;
  final int? divisionId;
  final String? divisionAcronym;
  final String? divisionDescription;
  final String? positionName;
  final int? order;
  final String? personName;
  final String? personPhotoUrl;
  final String? profilePicture;
  final String? photoUrl;

  RemoteVotingModel({
    required this.externalId,
    required this.eventId,
    required this.divisionId,
    required this.divisionAcronym,
    required this.divisionDescription,
    required this.positionName,
    required this.order,
    required this.personName,
    required this.personPhotoUrl,
    required this.profilePicture,
    required this.photoUrl,
  });

  factory RemoteVotingModel.fromJson(Map json) {
    if (!json.containsKey('ExternalId')) {
      throw HttpError.invalidData;
    }
    return RemoteVotingModel(
      externalId: json['ExternalId'],
      eventId: json['EventId'],
      divisionId: json['DivisionId'],
      divisionAcronym: json['DivisionAcronym'],
      divisionDescription: json['DivisionDescription'],
      positionName: json['PositionName'],
      order: json['Order'],
      personName: json['PersonName'],
      personPhotoUrl: json['PersonPhotoUrl'],
      profilePicture: json['PersonPhoto'],
      photoUrl: json['PhotoUrl'],
    );
  }

  VotingEntity toEntity() => VotingEntity(
        externalId: externalId,
        eventId: eventId,
        divisionId: divisionId,
        divisionAcronym: divisionAcronym,
        divisionDescription: divisionDescription,
        positionName: positionName,
        order: order,
        personName: personName,
        personPhotoUrl: personPhotoUrl,
        profilePicture: profilePicture,
        photoUrl: photoUrl,
      );
}
