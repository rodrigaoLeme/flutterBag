import 'package:flutter/material.dart';

import '../../mixins/mixins.dart';
import '../modules.dart';

abstract class NewsPresenter {
  Stream<bool> get isSessionExpiredStream;
  Stream<NavigationData?> get navigateToStream;
  Stream<NewsListViewModel?> get viewModel;
  ValueNotifier<VotingsViewModel?> get votingViewModel;

  Future<void> loadData();
  void dispose();
  void goToVoting();
  Future<void> fetchVotings();
}
