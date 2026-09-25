import '../../../../domain/usecases/enrollment/delete_family_member_usecase.dart';
import '../../../../domain/usecases/enrollment/load_extra_income_types_usecase.dart';
import '../../../../domain/usecases/enrollment/load_nationalities_usecase.dart';
import '../../../../domain/usecases/enrollment/load_occupation_types_usecase.dart';
import '../../../../domain/usecases/enrollment/load_scholarship_form_usecase.dart';
import '../../../../domain/usecases/enrollment/load_special_needs_usecase.dart';
import '../../../../domain/usecases/enrollment/lookup_person_usecase.dart';
import '../../../../domain/usecases/enrollment/lookup_zip_code_usecase.dart';
import '../../../../domain/usecases/enrollment/save_step_1_usecase.dart';
import '../../../../domain/usecases/enrollment/save_step_2_usecase.dart';
import '../../../../domain/usecases/enrollment/save_step_3_usecase.dart';
import '../../../../infra/repositories/enrollment/remote_delete_family_member_usecase.dart';
import '../../../../infra/repositories/enrollment/remote_load_extra_income_types_usecase.dart';
import '../../../../infra/repositories/enrollment/remote_load_nationalities_usecase.dart';
import '../../../../infra/repositories/enrollment/remote_load_occupation_types_usecase.dart';
import '../../../../infra/repositories/enrollment/remote_load_scholarship_form_usecase.dart';
import '../../../../infra/repositories/enrollment/remote_load_special_needs_usecase.dart';
import '../../../../infra/repositories/enrollment/remote_lookup_person_usecase.dart';
import '../../../../infra/repositories/enrollment/remote_lookup_zip_code_usecase.dart';
import '../../../../infra/repositories/enrollment/remote_save_family_member_usecase.dart';
import '../../../../infra/repositories/enrollment/remote_save_step_1_usecase.dart';
import '../../../../infra/repositories/enrollment/remote_save_step_2_usecase.dart';
import '../../../../infra/repositories/enrollment/remote_save_step_3_usecase.dart';
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

DeleteFamilyMemberUsecase makeRemoteDeleteFamilyMember() =>
    RemoteDeleteFamilyMemberUsecase(
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

LoadNationalitiesUsecase makeRemoteLoadNationalities() =>
    RemoteLoadNationalitiesUsecase(
      httpClient: makeAuthorizeHttpClientDecorator(),
    );

LoadExtraIncomeTypesUsecase makeRemoteLoadExtraIncomeTypes() =>
    RemoteLoadExtraIncomeTypesUsecase(
      httpClient: makeAuthorizeHttpClientDecorator(),
    );

SaveStep2Usecase makeRemoteSaveStep2() => RemoteSaveStep2Usecase(
      httpClient: makeAuthorizeHttpClientDecorator(),
    );

SaveStep3Usecase makeRemoteSaveStep3() => RemoteSaveStep3Usecase(
      httpClient: makeAuthorizeHttpClientDecorator(),
    );
