import 'member_registration_view_model.dart';

abstract class MemberRegistrationPresenter {
  MemberRegistrationViewModel get viewModel;
  int get currentSubStep;
  int get totalSubSteps;
  bool get canAdvance;

  void goToSubStep(int subStep);
  void decrementSubStep();
  void incrementSubStep();
  void commitMemberAndAdvance();

  void dispose();
}
