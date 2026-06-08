import '../../../../domain/usecases/home/load_available_process_periods_usecase.dart';
import '../../../../domain/usecases/home/load_home_data_usecase.dart';
import '../../../../domain/usecases/home/load_user_years_usecase.dart';
import '../../../../domain/usecases/home/load_year_scholarships_usecase.dart';
import '../../../../infra/repositories/home/remote_load_available_process_periods_usecase.dart';
import '../../../../infra/repositories/home/remote_load_user_years_usecase.dart';
import '../../../../infra/repositories/home/remote_load_year_scholarships_usecase.dart';
import '../../http/http_factories.dart';

LoadUserYearsUsecase makeRemoteLoadUserYears() => RemoteLoadUserYearsUsecase(
      httpClient: makeAuthorizeHttpClientDecorator(),
    );

LoadYearScholarshipsUsecase makeRemoteLoadYearScholarships() =>
    RemoteLoadYearScholarshipsUsecase(
      httpClient: makeAuthorizeHttpClientDecorator(),
    );

LoadAvailableProcessPeriodsUsecase makeRemoteLoadAvailableProcessPeriods() =>
    RemoteLoadAvailableProcessPeriodsUsecase(
      httpClient: makeAuthorizeHttpClientDecorator(),
    );

LoadHomeDataUsecase makeLoadHomeData() => LoadHomeDataUsecaseImpl(
      loadUserYears: makeRemoteLoadUserYears(),
      loadYearScholarships: makeRemoteLoadYearScholarships(),
      loadAvailableProcessPeriods: makeRemoteLoadAvailableProcessPeriods(),
    );
