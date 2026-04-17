import '../../../../presentation/presenters/social_media/stream_social_media_presenter.dart';
import '../../../../ui/modules/social_media/social_media_presenter.dart';
import '../../usecases/event/load_current_event_factory.dart';
import '../../usecases/social_media/load_social_media_factory.dart';

SocialMediaPresenter makeSocialMediaPresenter() => StreamSocialMediaPresenter(
      loadSocialMedia: makeRemoteLoadSocialMedia(),
      loadCurrentEvent: makeLocalLoadCurrentEvent(),
    );
