import 'package:flutter/material.dart';

import '../../mixins/mixins.dart';
import '../voting/voting_view_model.dart';

abstract class BusinessPresenter {
  Stream<bool> get isSessionExpiredStream;
  Stream<NavigationData?> get navigateToStream;
  ValueNotifier<VotingsViewModel?> get votingViewModel;

  Future<void> loadData();
  Future<void> fetchVotings();
  void goToVoting();
  void goToAgenda();
  void goToBrochures();
  void goToDocuments();
  void dispose();
}
