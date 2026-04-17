import 'dart:async';

import 'package:cpf_cnpj_validator/cpf_validator.dart';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/account/add_account.dart';
import '../../../domain/usecases/account/save_current_account.dart';
import '../../../main/routes/routes.dart';
import '../../../ui/mixins/navigation_data.dart';
import '../../../ui/modules/auth/add_account_presenter.dart';
import '../../../ui/modules/auth/add_account_view_model.dart';
import '../../mixins/mixins.dart';

class StreamAddAccountPresenter
    with SessionManager, LoadingManager, NavigationManager, UIErrorManager
    implements AddAccountPresenter {
  @override
  final AddAccount addAccount;
  final SaveCurrentAccount saveCurrentAccount;

  StreamAddAccountPresenter({
    required this.addAccount,
    required this.saveCurrentAccount,
  });

  final _viewModelController =
      StreamController<AddAccountViewModel?>.broadcast();

  @override
  Stream<AddAccountViewModel?> get viewModelStream =>
      _viewModelController.stream;

  @override
  Stream<bool?> get isLoadingStream => isLoadingStream;

  AddAccountViewModel _currentViewModel = const AddAccountViewModel.empty();

  String _name = '';
  String _email = '';
  String _cpf = '';
  String _phone = '';
  String _password = '';
  String _passwordConfirmation = '';

  @override
  void validateFields({
    required String name,
    required String email,
    required String cpf,
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) {
    _name = name.trim();
    _email = email.trim().toLowerCase();
    _cpf = cpf.replaceAll(RegExp(r'[^\d]'), '');
    _phone = phone.replaceAll(RegExp(r'[^\d]'), '');
    _password = password;
    _passwordConfirmation = passwordConfirmation;

    _currentViewModel = AddAccountViewModel(
      nameError: _name.length < 3 ? 'Informe seu nome completo.' : null,
      emailError: !RegExp(r'^[\w.]+@[\w]+\.\w{2,}$').hasMatch(_email)
          ? 'E-mail inválido.'
          : null,
      cpfError: !CPFValidator.isValid(_cpf) ? 'CPF inválido.' : null,
      phoneError: _phone.length < 10 ? 'Celular inválido.' : null,
      passwordError: _password.length < 8 ? 'Mínimo 8 caracteres.' : null,
      passwordConfirmationError:
          _password != _passwordConfirmation ? 'As senhas não conferem.' : null,
      isFormValid: _name.length >= 3 &&
          RegExp(r'^[\w.]+@[\w]+\.\w{2,}$').hasMatch(_email) &&
          CPFValidator.isValid(_cpf) &&
          _phone.length >= 10 &&
          _password.length >= 8 &&
          _password == _passwordConfirmation,
    );

    _viewModelController.add(_currentViewModel);
  }

  @override
  Future<void> addAccountCall() async {
    try {
      isLoading = LoadingData(isLoading: true);
      uiError = null;

      final account = await addAccount.add(AddAccountParams(
        name: _name,
        email: _email,
        cpf: _cpf,
        phone: _phone,
        password: _password,
        passwordConfirmation: _passwordConfirmation,
      ));

      await saveCurrentAccount.save(account.accessToken);
      navigateTo = NavigationData(route: Routes.contaCriada, clear: false);
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.emailInUse:
          uiError = 'Já existe uma conta com esse e-mail ou CPF.';
        case DomainError.noInternetConnection:
          uiError = 'Sem conexão com a internet.';
        default:
          uiError = 'Erro inesperado. Tente novamente.';
      }
    } finally {
      isLoading = LoadingData(isLoading: false);
    }
  }

  @override
  void dispose() {
    _viewModelController.close();
  }
}
