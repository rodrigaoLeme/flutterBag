import '../../../../domain/usecases/enrollment/load_scholarship_form_usecase.dart';
import '../../../../domain/usecases/enrollment/lookup_zip_code_usecase.dart';
import '../../../../domain/usecases/enrollment/save_step_1_usecase.dart';
import '../../../../infra/repositories/enrollment/remote_load_scholarship_form_usecase.dart';
import '../../../../infra/repositories/enrollment/remote_lookup_zip_code_usecase.dart';
import '../../../../infra/repositories/enrollment/remote_save_step_1_usecase.dart';
import '../../http/http_factories.dart';

SaveStep1Usecase makeRemoteSaveStep1() => RemoteSaveStep1Usecase(
      httpClient: makeAuthorizeHttpClientDecorator(),
    );

LoadScholarshipFormUsecase makeRemoteLoadScholarshipForm() =>
    RemoteLoadScholarshipFormUsecase(
      httpClient: makeAuthorizeHttpClientDecorator(),
    );

LookupZipCodeUsecase makeRemoteLookupZipCode() => RemoteLookupZipCodeUsecase(
      httpClient: makeDioAdapter(),
    );
