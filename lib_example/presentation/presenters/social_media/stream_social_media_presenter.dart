import 'dart:async';

import '../../../data/models/social_media/social_media_model.dart';
import '../../../domain/usecases/event/load_current_event.dart';
import '../../../domain/usecases/social_media/load_social_media.dart';
import '../../../ui/modules/social_media/social_media_presenter.dart';
import '../../../ui/modules/social_media/social_media_view_model.dart';
import '../../mixins/loading_manager.dart';
import '../../mixins/navigation_manager.dart';
import '../../mixins/session_manager.dart';
import '../../mixins/ui_error_manager.dart';

class StreamSocialMediaPresenter
    with SessionManager, LoadingManager, NavigationManager, UIErrorManager
    implements SocialMediaPresenter {
  final LoadSocialMedia loadSocialMedia;
  final LoadCurrentEvent loadCurrentEvent;

  StreamSocialMediaPresenter({
    required this.loadSocialMedia,
    required this.loadCurrentEvent,
  });

  final StreamController<SocialMediaViewModel?> _viewModel =
      StreamController<SocialMediaViewModel?>.broadcast();
  @override
  Stream<SocialMediaViewModel?> get viewModel => _viewModel.stream;

  @override
  void dispose() {
    _viewModel.close();
  }

  @override
  Future<void> convinienceInit() async {
    try {
      isLoading = LoadingData(isLoading: true);
      final currentEvent = await loadCurrentEvent.load();
      loadSocialMedia
          .load(
        params: LoadSocialMediaParams(
          eventId: currentEvent?.externalId ?? '',
        ),
      )
          ?.listen(
        (document) async {
          try {
            final model = RemoteSocialMediaModel.fromDocument(document);
            final eventDetailsModel =
                await SocialMediaViewModelFactory.make(model);
            _viewModel.add(eventDetailsModel);
          } catch (e) {
            _viewModel.addError(e);
          } finally {
            isLoading = LoadingData(isLoading: false);
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
}
