import 'package:flutter/material.dart';

import '../../../domain/usecases/get_proofs_with_pendences_by_family_params/params.dart';

class GroupWithPendencesDto {
  final Params getProofsWithPendencesParams;
  final String groupName;
  final IconData groupIcon;
  final String scholarshipReviewId;

  const GroupWithPendencesDto({
    required this.getProofsWithPendencesParams,
    required this.groupName,
    required this.groupIcon,
    required this.scholarshipReviewId,
  });
}
