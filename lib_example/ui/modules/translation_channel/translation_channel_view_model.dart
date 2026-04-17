import '../../../data/models/translation_channel/remote_translation_channel_model.dart';
import '../../helpers/extensions/string_extension.dart';

class TranslationChannelViewModel {
  final TranslationChannelResultViewModel? translationChannel;

  TranslationChannelViewModel({
    required this.translationChannel,
  });
}

class TranslationChannelResultViewModel {
  final String? externalId;
  final String? eventExternalId;
  final String? text;
  final String? link;

  TranslationChannelResultViewModel({
    required this.externalId,
    required this.eventExternalId,
    required this.text,
    required this.link,
  });
}

class TranslationChannelViewModelFactory {
  static Future<TranslationChannelViewModel> make(
      RemoteTranslationChannelModel model) async {
    final channel = model.translationChannel;

    return TranslationChannelViewModel(
      translationChannel: channel != null
          ? TranslationChannelResultViewModel(
              externalId: channel.externalId,
              eventExternalId: channel.eventExternalId,
              text: await channel.text?.translate(),
              link: channel.link,
            )
          : null,
    );
  }
}
