import 'package:flutter/material.dart';

import '../../../presentation/mixins/loading_manager.dart';
import '../../mixins/mixins.dart';
import '../agenda/agenda_view_model.dart';
import 'broadcast_view_model.dart';

abstract class BroadcastPresenter {
  Stream<bool> get isSessionExpiredStream;
  Stream<NavigationData?> get navigateToStream;
  Stream<BroadcastsViewModel?> get viewModel;
  Stream<LoadingData?> get isLoadingStream;
  Stream<AgendaViewModel?> get agendaViewModel;

  Future<void> loadData();
  ValueNotifier<BroadcastsViewModel?> get broadcastLanguages;
  Future<void> chooseLenguage(
      {required BroadcastLanguages language,
      required BroadcastsViewModel viewModel});
  void dispose();
  void selectCurrentFilter({
    required BroadcastFilter filter,
    required BroadcastsViewModel viewModel,
    required BroadcastDayPeriod broadcastDayPeriod,
  });
  void selectCurrentPlayer({
    required BroadcastViewModel broadcastViewModel,
    required BroadcastsViewModel viewModel,
  });
  Future<void> fetchAgenda();
  void languageBottomSheetInit(BroadcastsViewModel viewModel);
}
