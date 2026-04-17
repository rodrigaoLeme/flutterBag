import '../../../data/models/brochures/remote_brochures_model.dart';

class BrochuresViewModel {
  final List<BrochuresResultViewModel>? brochures;

  BrochuresViewModel({
    required this.brochures,
  });
}

class BrochuresResultViewModel {
  final String? externalId;
  final String? eventExternalId;
  final String? title;
  final String? link;

  BrochuresResultViewModel({
    required this.externalId,
    required this.eventExternalId,
    required this.title,
    required this.link,
  });
}

class BrochuresViewModelFactory {
  static BrochuresViewModel make(RemoteBrochuresModel model) {
    return BrochuresViewModel(
      brochures: model.result
          .map(
            (element) => BrochuresResultViewModel(
              externalId: element.externalId,
              eventExternalId: element.eventExternalId,
              title: element.title,
              link: element.link,
            ),
          )
          .toList(),
    );
  }
}
