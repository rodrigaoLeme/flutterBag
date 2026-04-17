import '../../mixins/navigation_data.dart';
import 'transport_view_model.dart';

abstract class TransportPresenter {
  Stream<bool> get isSessionExpiredStream;
  Stream<NavigationData?> get navigateToStream;
  Stream<TransportViewModel?> get viewModel;

  Future<void> loadData();
  void dispose();
}
