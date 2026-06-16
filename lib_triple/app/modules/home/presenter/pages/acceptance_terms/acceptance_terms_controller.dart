import '../scholarship_params.dart';
import '../select_group/stores/usecases/finish_sending_documents/store.dart'
    as finish_sending_documents;
import 'stores/usecases/advance_to_step_five/store.dart'
    as advance_to_step_five;
import 'stores/usecases/set_scholarship_step/store.dart'
    as set_scholarship_step;

class AcceptanceTermsController {
  final advance_to_step_five.Store advanceToStepFiveStore;
  final set_scholarship_step.Store setScholarshipStepStore;
  final finish_sending_documents.Store finishSendingDocumentsStore;
  final ScholarshipParams scholarshipParams;

  AcceptanceTermsController(
    this.advanceToStepFiveStore,
    this.setScholarshipStepStore,
    this.finishSendingDocumentsStore,
    this.scholarshipParams,
  );

  String get scholarshipId => scholarshipParams.id;
  String get processPeriodId => scholarshipParams.processPeriodId;

  Future<void> advanceToStepFive() async {
    await advanceToStepFiveStore(
      advance_to_step_five.Params(scholarshipId: scholarshipId),
    );
  }

  Future<void> revertToStepFour() async {
    await setScholarshipStepStore(
      set_scholarship_step.Params(
        processPeriodId: processPeriodId,
        scholarshipId: scholarshipId,
        step: 4,
      ),
    );
  }

  void finish({required String password, required bool acceptedTerms}) {
    finishSendingDocumentsStore(
      finish_sending_documents.Params(
        scholarshipId: scholarshipId,
        password: password,
        acceptedTerms: acceptedTerms,
      ),
    );
  }
}
