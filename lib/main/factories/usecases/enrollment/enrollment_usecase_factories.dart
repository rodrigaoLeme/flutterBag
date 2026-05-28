import '../../../../data/cache/enrollment_draft_storage.dart';
import '../../../../domain/usecases/enrollment/lookup_zip_code_usecase.dart';
import '../../../../domain/usecases/enrollment/save_step_1_usecase.dart';
import '../../../../infra/repositories/enrollment/remote_lookup_zip_code_usecase.dart';
import '../../../../infra/repositories/enrollment/remote_save_step_1_usecase.dart';
import '../../../di/injection_container.dart';
import '../../http/http_factories.dart';

SaveStep1Usecase makeRemoteSaveStep1() => RemoteSaveStep1Usecase(
      httpClient: makeAuthorizeHttpClientDecorator(),
      draftStorage: sl<EnrollmentDraftStorage>(),
    );

LookupZipCodeUsecase makeRemoteLookupZipCode() => RemoteLookupZipCodeUsecase(
      httpClient: makeDioAdapter(),
    );
