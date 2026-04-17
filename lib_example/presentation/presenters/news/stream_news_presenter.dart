import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../data/models/news/remote_news_model.dart';
import '../../../data/models/voting/remote_voting_model.dart';
import '../../../domain/usecases/event/load_current_event.dart';
import '../../../domain/usecases/usecases.dart';
import '../../../main/routes/routes_app.dart';
import '../../../ui/mixins/navigation_data.dart';
import '../../../ui/modules/modules.dart';
import '../../mixins/mixins.dart';

class StreamNewsPresenter
    with SessionManager, LoadingManager, NavigationManager, UIErrorManager
    implements NewsPresenter {
  final LoadNews loadNews;
  final LoadCurrentEvent loadCurrentEvent;
  final LoadVoting loadVoting;

  StreamNewsPresenter({
    required this.loadNews,
    required this.loadCurrentEvent,
    required this.loadVoting,
  });

  final StreamController<NewsListViewModel?> _viewModel =
      StreamController<NewsListViewModel?>.broadcast();
  @override
  Stream<NewsListViewModel?> get viewModel => _viewModel.stream;

  final ValueNotifier<VotingsViewModel?> _votingViewModel =
      ValueNotifier<VotingsViewModel?>(null);
  @override
  ValueNotifier<VotingsViewModel?> get votingViewModel => _votingViewModel;

  @override
  Future<void> loadData() async {
    try {
      final currentEvent = await loadCurrentEvent.load();

      loadNews
          .load(params: LoadNewsParams(eventId: currentEvent?.externalId ?? ''))
          ?.listen(
        (document) async {
          try {
            final model = RemoteListNewsModel.fromDocument(document);

            final viewModel = await NewsViewModelFactory.make(
                RemoteListNewsModel(newsList: model.newsList));

            _viewModel.add(viewModel);
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
    _viewModel.close();
  }

  @override
  void goToVoting() {
    navigateTo = NavigationData(
      route: Routes.voting,
      clear: false,
    );
  }
}
