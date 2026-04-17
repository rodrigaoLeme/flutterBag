import '../../../data/models/social_media/social_media_model.dart';
import '../../helpers/extensions/string_extension.dart';

class SocialMediaViewModel {
  final SocialMediaResultViewModel? socialMedia;

  SocialMediaViewModel({
    required this.socialMedia,
  });
}

class SocialMediaResultViewModel {
  final String? externalId;
  final String? eventExternalId;
  final String? text;
  final String? link;

  SocialMediaResultViewModel({
    required this.externalId,
    required this.eventExternalId,
    required this.text,
    required this.link,
  });
}

class SocialMediaViewModelFactory {
  static Future<SocialMediaViewModel> make(RemoteSocialMediaModel model) async {
    final social = model.socialMediaModel;

    return SocialMediaViewModel(
      socialMedia: social != null
          ? SocialMediaResultViewModel(
              externalId: social.externalId,
              eventExternalId: social.eventExternalId,
              text: await social.text?.translate(),
              link: social.link,
            )
          : null,
    );
  }
}
