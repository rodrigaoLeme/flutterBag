import 'package:flutter/material.dart';

import '../../domain/usecases/get_proofs_by_family_params/params.dart';

class GroupParams {
  Params? proofParams;
  String? groupName;
  IconData? icon;

  GroupParams({required this.proofParams, required this.icon, required this.groupName});
  factory GroupParams.empty() => GroupParams(proofParams: null, icon: null, groupName: null);
}
