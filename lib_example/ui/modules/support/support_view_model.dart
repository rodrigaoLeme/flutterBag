import '../../../data/models/support/remote_support_model.dart';
import '../../helpers/extensions/string_extension.dart';

class SupportViewModel {
  final List<SupportResultViewModel>? support;
  List<SupportResultViewModel>? supportFiltered;

  SupportViewModel({
    required this.support,
  }) : supportFiltered = support;

  void filterBy(String text) {
    if (text == '') {
      supportFiltered = support;
    } else {
      final query = text.toLowerCase();
      supportFiltered = support
          ?.where(
            (element) =>
                element.title?.toLowerCase().contains(query) == true ||
                element.description?.toLowerCase().contains(query) == true,
          )
          .toList();
    }
  }
}

class SupportResultViewModel {
  final String? externalId;
  final String? eventExternalId;
  final String? title;
  final String? description;

  SupportResultViewModel({
    required this.externalId,
    required this.eventExternalId,
    required this.title,
    required this.description,
  });
}

class SupportViewModelFactory {
  static Future<SupportViewModel> make(RemoteSupportModel model) async {
    return SupportViewModel(
      support: model.support != null
          ? await Future.wait<SupportResultViewModel>(
              model.support!.map(
                (element) async => SupportResultViewModel(
                  externalId: element.externalId,
                  eventExternalId: element.eventExternalId,
                  title: await element.title?.translate(),
                  description: await element.description?.translate(),
                ),
              ),
            )
          : [],
    );
  }
}
