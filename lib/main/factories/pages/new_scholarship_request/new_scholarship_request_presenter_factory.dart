import '../../../../data/cache/enrollment_draft_storage.dart';
import '../../../../presentation/presenters/new_scholarship_request/stream_new_scholarship_request_presenter.dart';
import '../../../../ui/modules/new_request/new_scholarship_request_presenter.dart';
import '../../../di/injection_container.dart';
import '../../usecases/enrollment/enrollment_usecase_factories.dart';

NewScholarshipRequestPresenter makeNewRequestPresenter({
  required String processPeriodId,
}) =>
    StreamNewScholarshipRequestPresenter(
      processPeriodId: processPeriodId,
      saveStep1Usecase: makeRemoteSaveStep1(),
      lookupZipCodeUsecase: makeRemoteLookupZipCode(),
      loadScholarshipFormUsecase: makeRemoteLoadScholarshipForm(),
      draftStorage: sl<EnrollmentDraftStorage>(),
    );
