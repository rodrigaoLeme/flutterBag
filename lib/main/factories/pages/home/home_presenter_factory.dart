import '../../../../presentation/presenters/home/stream_home_presenter.dart';
import '../../../../ui/modules/home/home_presenter.dart';
import '../../usecases/home/home_usecase_factories.dart';

HomePresenter makeHomePresenter() => StreamHomePresenter(
      loadHomeData: makeLoadHomeData(),
      loadYearScholarships: makeRemoteLoadYearScholarships(),
      loadAvailableProcessPeriods: makeRemoteLoadAvailableProcessPeriods(),
    );
