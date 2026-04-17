class VotingResultEntity {
  final List<VotingEntity>? votings;

  VotingResultEntity({
    required this.votings,
  });
}

class VotingEntity {
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

  VotingEntity({
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
}
