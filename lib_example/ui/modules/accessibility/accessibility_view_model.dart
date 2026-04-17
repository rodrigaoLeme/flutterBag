import '../../../data/models/accessibility/accessibility_model.dart';
import '../../helpers/extensions/string_extension.dart';

class AccessibilityViewModel {
  final AccessibilityResultViewModel? accessibility;

  AccessibilityViewModel({
    required this.accessibility,
  });
}

class AccessibilityResultViewModel {
  final String? externalId;
  final String? eventExternalId;
  final String? text;
  final String? link;

  AccessibilityResultViewModel({
    required this.externalId,
    required this.eventExternalId,
    required this.text,
    required this.link,
  });
}

class AccessibilityViewModelFactory {
  static Future<AccessibilityViewModel> make(
      RemoteAccessibilityModel model) async {
    final access = model.accessibility;

    return AccessibilityViewModel(
      accessibility: access != null
          ? AccessibilityResultViewModel(
              externalId: access.externalId,
              eventExternalId: access.eventExternalId,
              text: await access.text?.translate(),
              link: access.link,
            )
          : null,
    );
  }
}
