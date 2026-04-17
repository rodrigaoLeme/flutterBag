import '../../../../presentation/presenters/auth/stream_add_account_presenter.dart';
import '../../../../ui/modules/auth/add_account_presenter.dart';
import '../../usecases/account/add_account_factory.dart';
import '../../usecases/account/save_current_account_factory.dart';

AddAccountPresenter makeAddAccountPresenter() => StreamAddAccountPresenter(
      addAccount: makeRemoteAddAccount(),
      saveCurrentAccount: makeLocalSaveCurrentAccount(),
    );
