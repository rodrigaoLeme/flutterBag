import 'dart:async';

import '../../mixins/mixins.dart';
import '../modules.dart';

abstract class VotingPresenter {
  Stream<bool> get isSessionExpiredStream;
  Stream<NavigationData?> get navigateToStream;
  Stream<VotingsViewModel?> get viewModel;

  Future<void> loadData();
  void dispose();
  VotingsViewModel? setFilter(
      VotingsViewModel? votingViewModel, DivisionGroup filter);
  VotingsViewModel? filterBy(VotingsViewModel? votingViewModel, String filter);
  void filterVotingBy(
    String filter,
    VotingsViewModel? votingViewModel,
  );
  void clealAllFilters(VotingsViewModel? votingViewModel);
}
