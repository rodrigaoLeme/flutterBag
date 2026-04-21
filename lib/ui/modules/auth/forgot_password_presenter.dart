import '../../../presentation/mixins/loading_manager.dart';
import '../../mixins/navigation_data.dart';

abstract class ForgotPasswordPresenter {
  Stream<NavigationData?> get navigateToStream;
  Stream<String?> get uiErrorStream;
  Stream<LoadingData?> get isLoadingStream;
  Stream<bool?> get isSuccessStream;

  Future<void> forgotPassword({required String identifier});

  void dispose();
}
