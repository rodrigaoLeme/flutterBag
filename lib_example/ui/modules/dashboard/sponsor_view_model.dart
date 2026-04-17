import '../../../data/models/sponsor/remote_sponsor_model.dart';
import '../../helpers/extensions/string_extension.dart';

class SponsorsViewModel {
  final List<SponsorViewModel>? sponsors;

  SponsorsViewModel({
    required this.sponsors,
  });
}

class SponsorViewModel {
  final String? externalId;
  final String? eventExternalId;
  final String? name;
  final String? link;
  final String? photoUrl;

  SponsorViewModel({
    required this.externalId,
    required this.eventExternalId,
    required this.name,
    required this.link,
    required this.photoUrl,
  });
}

class SponsorsViewModelFactory {
  static Future<SponsorsViewModel> make(RemoteSponsorModel model) async {
    return SponsorsViewModel(
      sponsors: model.sponsor != null
          ? await Future.wait<SponsorViewModel>(
              model.sponsor!.map(
                (element) async => SponsorViewModel(
                  externalId: element.externalId,
                  eventExternalId: element.eventExternalId,
                  name: await element.name?.translate(),
                  link: element.link,
                  photoUrl: element.photoUrl,
                ),
              ),
            )
          : [],
    );
  }
}
