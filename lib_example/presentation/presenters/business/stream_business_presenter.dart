import 'package:flutter/foundation.dart';

import '../../../data/models/voting/remote_voting_model.dart';
import '../../../domain/usecases/business/load_business.dart';
import '../../../domain/usecases/event/load_current_event.dart';
import '../../../domain/usecases/voting/load_voting.dart';
import '../../../main/routes/routes_app.dart';
import '../../../ui/mixins/navigation_data.dart';
import '../../../ui/modules/business/business_presenter.dart';
import '../../../ui/modules/modules.dart';
import '../../mixins/mixins.dart';

class StreamBusinessPresenter
    with SessionManager, LoadingManager, NavigationManager, UIErrorManager
    implements BusinessPresenter {
  final LoadBusiness loadBusiness;
  final LoadVoting loadVoting;
  final LoadCurrentEvent loadCurrentEvent;

  StreamBusinessPresenter({
    required this.loadBusiness,
    required this.loadVoting,
    required this.loadCurrentEvent,
  });

  final ValueNotifier<VotingsViewModel?> _votingViewModel =
      ValueNotifier<VotingsViewModel?>(null);
  @override
  ValueNotifier<VotingsViewModel?> get votingViewModel => _votingViewModel;

  @override
  Future<void> loadData() async {}

  @override
  void goToVoting() {
    navigateTo = NavigationData(
      route: Routes.voting,
      clear: false,
    );
  }

  @override
  Future<void> fetchVotings() async {
    try {
      final event = await loadCurrentEvent.load();
      loadVoting
          .load(params: LoadVotingParams(eventId: event?.externalId ?? ''))
          ?.listen(
        (document) async {
          try {
            final model = VotingResultModel.fromDocument(document);
            final votingViewModel =
                await VotingsViewModelFactory.make(model: model);
            _votingViewModel.value = votingViewModel;
          } catch (e) {
            _votingViewModel.value = null;
          }
        },
        onError: (error) {
          _votingViewModel.value = null;
        },
      );
    } catch (error) {
      _votingViewModel.value = null;
    }
  }

  @override
  void dispose() {
    _votingViewModel.dispose();
  }

  @override
  void goToAgenda() {
    navigateTo = NavigationData(
      route: Routes.agenda,
      clear: false,
      arguments: SchedulePageNavigationData(
        currentIndex: 1,
        shouldPresentArrowBack: true,
      ),
    );
  }

  @override
  void goToBrochures() {
    navigateTo = NavigationData(
      route: Routes.brochures,
      clear: false,
    );
  }

  @override
  void goToDocuments() {
    navigateTo = NavigationData(
      route: Routes.documents,
      clear: false,
    );
  }
}
