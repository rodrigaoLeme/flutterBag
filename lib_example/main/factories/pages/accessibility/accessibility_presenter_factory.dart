import '../../../../presentation/presenters/accessibility/stream_accessibility_presenter.dart';
import '../../../../ui/modules/accessibility/accessibility_presenter.dart';
import '../../usecases/accessibility/load_accessibility_factory.dart';
import '../../usecases/event/load_current_event_factory.dart';

AccessibilityPresenter makeAccessibilityPresenter() =>
    StreamAccessibilityPresenter(
      loadAccessibility: makeRemoteLoadAccessibility(),
      loadCurrentEvent: makeLocalLoadCurrentEvent(),
    );
