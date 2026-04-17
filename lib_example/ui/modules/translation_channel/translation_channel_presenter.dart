import '../../mixins/navigation_data.dart';
import 'translation_channel_view_model.dart';

abstract class TranslationChannelPresenter {
  Stream<bool> get isSessionExpiredStream;
  Stream<NavigationData?> get navigateToStream;
  Stream<TranslationChannelViewModel?> get viewModel;

  Future<void> loadData();
  void dispose();
}
