import '../../../../domain/usecases/enrollment/load_occupation_types_usecase.dart';
import '../../../../domain/usecases/enrollment/load_scholarship_form_usecase.dart';
import '../../../../domain/usecases/enrollment/load_special_needs_usecase.dart';
import '../../../../domain/usecases/enrollment/lookup_person_usecase.dart';
import '../../../../domain/usecases/enrollment/lookup_zip_code_usecase.dart';
import '../../../../domain/usecases/enrollment/save_step_1_usecase.dart';
import '../../../../domain/usecases/enrollment/save_step_2_usecase.dart';
import '../../../../infra/repositories/enrollment/remote_load_occupation_types_usecase.dart';
import '../../../../infra/repositories/enrollment/remote_load_scholarship_form_usecase.dart';
import '../../../../infra/repositories/enrollment/remote_load_special_needs_usecase.dart';
import '../../../../infra/repositories/enrollment/remote_lookup_person_usecase.dart';
import '../../../../infra/repositories/enrollment/remote_lookup_zip_code_usecase.dart';
import '../../../../infra/repositories/enrollment/remote_save_family_member_usecase.dart';
import '../../../../infra/repositories/enrollment/remote_save_step_1_usecase.dart';
import '../../../../infra/repositories/enrollment/remote_save_step_2_usecase.dart';
import '../../http/http_factories.dart';

SaveStep1Usecase makeRemoteSaveStep1() => RemoteSaveStep1Usecase(
      httpClient: makeAuthorizeHttpClientDecorator(),
    );

LoadScholarshipFormUsecase makeRemoteLoadScholarshipForm() =>
    RemoteLoadScholarshipFormUsecase(
      httpClient: makeAuthorizeHttpClientDecorator(),
    );

LookupZipCodeUsecase makeRemoteLookupZipCode() => RemoteLookupZipCodeUsecase(
      httpClient: makeAuthorizeHttpClientDecorator(),
    );

RemoteSaveFamilyMemberUsecase makeRemoteSaveFamilyMember() =>
    RemoteSaveFamilyMemberUsecase(
      httpClient: makeAuthorizeHttpClientDecorator(),
    );

LookupPersonUsecase makeRemoteLookupPerson() => RemoteLookupPersonUsecase(
      httpClient: makeAuthorizeHttpClientDecorator(),
    );

LoadSpecialNeedsUsecase makeRemoteLoadSpecialNeeds() =>
    RemoteLoadSpecialNeedsUsecase(
      httpClient: makeAuthorizeHttpClientDecorator(),
    );

LoadOccupationTypesUsecase makeRemoteLoadOccupationTypes() =>
    RemoteLoadOccupationTypesUsecase(
      httpClient: makeAuthorizeHttpClientDecorator(),
    );

SaveStep2Usecase makeRemoteSaveStep2() => RemoteSaveStep2Usecase(
      httpClient: makeAuthorizeHttpClientDecorator(),
    );
