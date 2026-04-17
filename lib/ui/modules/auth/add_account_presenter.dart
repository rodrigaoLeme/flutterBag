import '../../mixins/navigation_data.dart';
import 'add_account_view_model.dart';

abstract class AddAccountPresenter {
  Stream<NavigationData?> get navigateToStream;
  Stream<String?> get uiErrorStream;
  Stream<bool?> get isLoadingStream;
  Stream<AddAccountViewModel?> get viewModelStream;

  void validateFields({
    required String name,
    required String email,
    required String cpf,
    required String phone,
    required String password,
    required String passwordConfirmation,
  });

  Future<void> addAccount();

  void dispose();
}
