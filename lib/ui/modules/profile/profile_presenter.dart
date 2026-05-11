import '../../../presentation/mixins/mixins.dart';
import 'profile_view_model.dart';

abstract class ProfilePresenter {
  Stream<ProfileViewModel?> get viewModel;
  Stream<bool> get isSessionExpiredStream;
  Stream<LoadingData?> get isLoadingStream;
  Stream<String?> get uiSuccessStream;
  Stream<String?> get uiErrorStream;

  void loadData();
  void validateAndSave({
    required String email,
    required String phone,
  });
  Future<void> logout();
  void dispose();
}
