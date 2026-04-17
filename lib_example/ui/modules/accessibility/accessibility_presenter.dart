import '../../mixins/navigation_data.dart';
import 'accessibility_view_model.dart';

abstract class AccessibilityPresenter {
  Stream<bool> get isSessionExpiredStream;
  Stream<NavigationData?> get navigateToStream;
  Stream<AccessibilityViewModel?> get viewModel;

  Future<void> loadData();
  void dispose();
}
