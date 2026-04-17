import '../../mixins/mixins.dart';
import 'brochures_view_model.dart';

abstract class BrochuresPresenter {
  Stream<bool> get isSessionExpiredStream;
  Stream<NavigationData?> get navigateToStream;
  Stream<BrochuresViewModel?> get brochuresViewModel;

  Future<void> loadData();
  void dispose();
}
