import 'dart:async';

import '../../../../ui/modules/new_request/steps/family/member_registration_presenter.dart';
import '../../../../ui/modules/new_request/steps/family/member_registration_sub_step_config.dart';
import '../../../../ui/modules/new_request/steps/family/member_registration_view_model.dart';

class StreamMemberRegistrationPresenter implements MemberRegistrationPresenter {
  StreamMemberRegistrationPresenter({
    MemberRegistrationViewModel? viewModel,
    bool isHigherEducation = false,
  }) : viewModel = viewModel ??
            MemberRegistrationViewModel(
              isHigherEducation: isHigherEducation,
            ) {
    _currentSubStepController.add(_currentSubStep);
    this.viewModel.addListener(_emitSubStep);
  }

  @override
  final MemberRegistrationViewModel viewModel;

  final _currentSubStepController = StreamController<int>.broadcast();
  int _currentSubStep = 1;

  Stream<int> get currentSubStepStream => _currentSubStepController.stream;

  @override
  int get currentSubStep => _currentSubStep;

  @override
  int get totalSubSteps => memberRegistrationSubStepCount;

  @override
  bool get canAdvance => viewModel.canAdvanceSubStep(_currentSubStep);

  void _emitSubStep() => _currentSubStepController.add(_currentSubStep);

  @override
  void goToSubStep(int subStep) {
    _currentSubStep = subStep.clamp(1, totalSubSteps);
    _emitSubStep();
  }

  @override
  void decrementSubStep() {
    if (_currentSubStep <= 1) return;
    _currentSubStep--;
    _emitSubStep();
  }

  @override
  void incrementSubStep() {
    if (_currentSubStep >= totalSubSteps) return;
    _currentSubStep++;
    _emitSubStep();
  }

  @override
  void commitMemberAndAdvance() {
    viewModel.commitCurrentMemberToList();
    incrementSubStep();
  }

  @override
  void dispose() {
    viewModel.removeListener(_emitSubStep);
    viewModel.dispose();
    _currentSubStepController.close();
  }
}
