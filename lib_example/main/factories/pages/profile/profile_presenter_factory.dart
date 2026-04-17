import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/modules/modules.dart';
import '../../usecases/usecases.dart';

ProfilePresenter makeProfilePresenter() =>
    StreamProfilePresenter(loadProfile: makeRemoteLoadProfile());
