import 'dart:developer';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

import '../../../../core/stores/proxies/auth/auth_proxy_store.dart';
import '../../domain/usecases/login_with_id/exceptions.dart';
import '../../domain/usecases/login_with_id/login_with_id_usecase.dart';
import '../../domain/usecases/login_with_id/params.dart';
import 'login_with_id_store_error.dart';
import 'login_with_id_store_state.dart';

class LoginWithIdStore extends StreamStore<LoginWithIdStoreError, LoginWithIdStoreState> {
  final AuthProxyStore _authProxyStore;
  final LoginWithIdUsecase usecase;
  LoginWithIdStore(this.usecase, this._authProxyStore) : super(LoginWithIdStoreInitialState());

  Future<void> login(LoginWithIdParams params) async {
    setLoading(true);
    return usecase(params).then(
      (result) {
        return result.fold(
          (exception) {
            late LoginWithIdStoreError error;
            if (exception is NotValidFieldsException) {
              error = LoginWithIdStoreError(idFieldError: exception.idMessage, passwordFieldError: exception.passwordMessage);
            } else {
              error = LoginWithIdStoreError(authError: exception.message);
            }
            setError(error);
            setLoading(false);
          },
          (result) {
            log('Usuário configurado na Session');
            _authProxyStore.storeNewSession(result).then((value) {
              update(LoginWithIdStoreSuccessState());
              setLoading(false);
              Modular.to.pushReplacementNamed('../home/');
            });
          },
        );
      },
    );
  }
}
