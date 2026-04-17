import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/modules/modules.dart';
import '../../usecases/usecases.dart';

StLouisPresenter makeStLouisPresenter() => StreamStLouisPresenter(
      loadStLouis: makeRemoteLoadStLouis(),
    );
