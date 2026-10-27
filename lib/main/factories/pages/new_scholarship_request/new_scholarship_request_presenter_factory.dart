import '../../../../data/cache/enrollment_draft_storage.dart';
import '../../../../domain/entities/announcement_enums.dart';
import '../../../../presentation/presenters/new_scholarship_request/stream_new_scholarship_request_presenter.dart';
import '../../../../ui/modules/new_request/new_scholarship_request_presenter.dart';
import '../../../di/injection_container.dart';
import '../../usecases/enrollment/enrollment_usecase_factories.dart';

NewScholarshipRequestPresenter makeNewRequestPresenter({
  required String processPeriodId,
  String? scholarshipId,
  EducationLevel? educationLevel,
}) =>
    StreamNewScholarshipRequestPresenter(
      processPeriodId: processPeriodId,
      scholarshipId: scholarshipId,
      educationLevel: educationLevel,
      saveStep1Usecase: makeRemoteSaveStep1(),
      saveStep3Usecase: makeRemoteSaveStep3(),
      saveStep4Usecase: makeRemoteSaveStep4(),
      lookupZipCodeUsecase: makeRemoteLookupZipCode(),
      loadScholarshipFormUsecase: makeRemoteLoadScholarshipForm(),
      draftStorage: sl<EnrollmentDraftStorage>(),
    );
