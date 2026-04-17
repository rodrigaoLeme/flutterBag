import 'dart:async';

import '../../../data/models/voting/remote_voting_model.dart';
import '../../../domain/usecases/event/load_current_event.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../ui/modules/modules.dart';
import '../../mixins/mixins.dart';

class StreamVotingPresenter
    with SessionManager, LoadingManager, NavigationManager, UIErrorManager
    implements VotingPresenter {
  final LoadVoting loadVoting;
  final LoadCurrentEvent loadCurrentEvent;

  StreamVotingPresenter({
    required this.loadVoting,
    required this.loadCurrentEvent,
  });

  final StreamController<VotingsViewModel?> _viewModel =
      StreamController<VotingsViewModel?>.broadcast();
  @override
  Stream<VotingsViewModel?> get viewModel => _viewModel.stream;

  @override
  Future<void> loadData() async {
    try {
      final currentEvent = await loadCurrentEvent.load();
      loadVoting
          .load(
              params: LoadVotingParams(eventId: currentEvent?.externalId ?? ''))
          ?.listen(
        (document) async {
          try {
            final model = VotingResultModel.fromDocument(document);
            final votingViewModel =
                await VotingsViewModelFactory.make(model: model);
            _viewModel.add(votingViewModel);
          } catch (e) {
            _viewModel.addError(e);
          }
        },
        onError: (error) {
          _viewModel.addError(error);
        },
      );
    } catch (error) {
      _viewModel.addError(error);
    }
  }

  @override
  void dispose() {
    _viewModel.close();
  }

  @override
  VotingsViewModel? setFilter(
      VotingsViewModel? votingViewModel, DivisionGroup filter) {
    votingViewModel?.setCurrentFilter(filter);
    _viewModel.add(votingViewModel);
    return votingViewModel;
  }

  @override
  void clealAllFilters(VotingsViewModel? votingViewModel) {
    votingViewModel?.clearFilter();
    _viewModel.add(votingViewModel);
  }

  @override
  VotingsViewModel? filterBy(VotingsViewModel? votingViewModel, String filter) {
    votingViewModel?.filterBy(filter);
    return votingViewModel;
  }

  @override
  void filterVotingBy(String filter, VotingsViewModel? votingViewModel) {
    votingViewModel?.filterVotingBy(filter);
    _viewModel.add(votingViewModel);
  }
}
